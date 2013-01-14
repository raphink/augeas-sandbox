This is a collection of scripts that are useful to use with Augeas.

They might (or not) be one day ported to real programs into the Augeas project.

augload
=======

`augload` allows to load files dynamically using a specific lens.
As of Augeas 1.0.0, this functionality is available in `augtool` using the `--transform` option,
and this tool is thus obsolete.

augcheck
========

`augcheck` is a tool to check if a lens is able to parse for a given file.

auggrep
=======

`auggrep` allows to grep for expressions in an input stream:

  $ head /var/log/syslog | AUGEAS_LENS_LIB=. ./auggrep -l -f logs.commands Logs.syslog
  /parsed/1/date/time = 09:29:21
  /parsed/1/date/time = 09:29:31
  /parsed/1/date/time = 09:29:31
  /parsed/1/date/time = 09:35:01
  /parsed/1/date/time = 09:39:01
  /parsed/1/date/time = 09:45:01
  /parsed/1/date/time = 09:55:01
  /parsed/1/date/time = 09:56:47
  /parsed/1/date/time = 09:56:47
  /parsed/1/date/time = 09:56:47


augsed
======

You can use `augsed` to modify an input stream:

  $ getent passwd  | ./augsed Passwd.lns 'set *[uid="0"]/name "Robert Oot"'



