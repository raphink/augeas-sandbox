#!/usr/bin/env ruby

require 'augeas'
require 'optparse'

format = 'shell'
lensdir = '/usr/share/augeas/lenses/dist'

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-f", "--format FORMAT", "Specify format (html)") do |f|
    format = f
  end
  opts.on("-l", "--lensdir DIR", "Specify lens directory") do |d|
    lensdir = d
  end
end.parse!

aug = Augeas.open()

lenses = Hash.new
Dir.glob("#{lensdir}/*.aug").each do |file|
  autoload = false
  mod = nil
  File.open(file).each do |line|
    if line =~ /^\s*module\s+(\w+)\s*=\s*/
      mod = $1
      break
    end
  end

  unless defined? mod
    warn "Could not determine module for file #{file}\n"
    next
  end

  includes = []
  excludes = []
  path = "/augeas/load/#{mod}"
  unless aug.match(path).empty?
    autoload = true
    lns = aug.get("#{path}/lens").sub!(/^@/,"")
    aug.match("#{path}/incl").each do |incl|
      includes << aug.get(incl)
    end
    aug.match("#{path}/excl").each do |excl|
      excludes << aug.get(excl)
    end
  end

  lenses[mod] = {
    :lens => lns,
    :autoload => autoload,
    :incl => includes,
    :excl => excludes,
  }
end

if format == 'shell'
  lenses.keys.sort.each do |lns|
    autoload = lenses[lns][:autoload]
    includes = lenses[lns][:incl]
    excludes = lenses[lns][:excl]
    puts "Lens #{lns}: \n"
    puts "   autoload: #{autoload}\n"
    puts "   incl: #{includes.join(', ')}\n" unless includes.empty?
    puts "   excl: #{excludes.join(', ')}\n" unless excludes.empty?
  end
elsif format == 'html'
  puts "<html><head>"
  puts "<style type='text/css'>

    table {
    width:90%;
    border-top:1px solid #e5eff8;
    border-right:1px solid #e5eff8;
    margin:1em auto;
    border-collapse:collapse;
    }
    td {
    color:#678197;
    border-bottom:1px solid #e5eff8;
    border-left:1px solid #e5eff8;
    padding:.3em 1em;
    text-align:center;
    }
</style>"
  puts "</head><body>"
  puts "<table><thead>"
  puts "<th>Lens</th><th>Autoload</th><th>Includes</th><th>Excludes</th>"
  puts "</thead>"
  puts "<tbody>"
  lenses.keys.sort.each do |lns|
    autoload = lenses[lns][:autoload]
    includes = lenses[lns][:incl]
    excludes = lenses[lns][:excl]
    puts "<tr>\n"
    puts "  <td>#{lns}</td>\n"
    puts "  <td>#{autoload}</td>\n"
    puts "  <td>#{autoload ? includes.join('<br />') : 'N/A'}</td>\n"
    puts "  <td>#{autoload ? excludes.join('<br />') : 'N/A'}</td>\n"
    puts "</tr>\n"
  end
  puts "</tbody></table>"
  puts "</body></html>"
end

