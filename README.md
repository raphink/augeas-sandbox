This is a collection of scripts that are useful to use with Augeas.

They might (or not) be one day ported to real programs into the Augeas project.

augload
=======

`augload` allows to load files dynamically using a specific lens.
As of Augeas 1.0.0, this functionality is available in `augtool` using the `--transform` option,
and this tool is thus obsolete.

augloadone
==========

`augloadone` takes a single file name. It loads `augtool` to parse only this file, removing all other lenses. It is an alternative to `augtool` (or using `--transform`) which doesn't involve knowing the lens name. It also sets the context automatically.

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

augparsediff
============

`augparse` is a wrapper for the regular `augparse`, usually used to run tests contained within modules.  When comparing trees in tests, `augparsediff` prints a regular unified diff of the expected versus actual tree, making it easier to find the differences.

```diff
$ augparsediff -c -I lenses/ lenses/tests/test_mysql.aug 
Syntax error in lens definition
Failed to load lenses/tests/test_mysql.aug
--- expected	2015-06-12 11:25:32.982707547 +0200
+++ actual	2015-06-12 11:25:32.986707733 +0200
@@ -113,6 +113,9 @@
     { "max_allowed_packet" = "16M" }
     {  }
   }
+  { "!includedir" = "/etc/mysql/middle_include" }
+  { "!include" = "/etc/mysql/middle_include.conf" }
+  {  }
   { "target" = "mysql"
     { "#comment" = "no-auto-rehash	# faster start of mysql but no tab completition" }
     {  }
```

augsed
======

You can use `augsed` to modify an input stream:

    $ getent passwd  | ./augsed Passwd.lns 'set *[uid="0"]/name "Robert Oot"'
    root:x:0:0:Robert Oot:/root:/bin/bash
    daemon:x:1:1:daemon:/usr/sbin:/bin/sh
    bin:x:2:2:bin:/bin:/bin/sh
    sys:x:3:3:sys:/dev:/bin/sh
    sync:x:4:65534:sync:/bin:/bin/sync
    games:x:5:60:games:/usr/games:/bin/sh
    man:x:6:12:man:/var/cache/man:/bin/sh
    lp:x:7:7:lp:/var/spool/lpd:/bin/sh
    mail:x:8:8:mail:/var/mail:/bin/sh
    news:x:9:9:news:/var/spool/news:/bin/sh
    uucp:x:10:10:uucp:/var/spool/uucp:/bin/sh
    proxy:x:13:13:proxy:/bin:/bin/sh
    www-data:x:33:33:www-data:/var/www:/bin/sh
    backup:x:34:34:backup:/var/backups:/bin/sh




