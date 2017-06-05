# Background launch

This is a simple shell background task launcher with output redirection to user-specified log-files.

# Installing

You place this script into your home directory (`~/`) and use in your `bash.rc` the following line
to load it every time the computer is started:

```
$ source ~/launch_bg.sh
```

# Launching a task

```
# bg_launch "instructions" "stdout" "stderr" "pid.kill"
```

You *must* use quotes for the arguments if you want to have spaces... please be aware of that. Let's
say you wanted to launch a `ping` task and log the output, this could be achieved as follows:

```
# bg_launch "ping wwww.google.com"
Warning -- One argument received, stdout at: ~/out.log, stderr at: ~/err.log, kill pid at: ~/pid.kill
[1] 27913
Launching background command: ping www.google.com
```

This will start a background task pinging regularly to `google` and putting `stdout` output 
in `~/out.log` and `stderr` in `~/err.log`.

# Killing a task

The task is killed by using the `pid` of the launched background process which was saved in a file; the
default location is: `~/pid.kill` which is the default lookup location should no arguments are provided
when launching `bg_kill` as such:

```
$ bg_kill
```

Then, if we had launched the previous command we would expect the following output when running `bg_kill`
with no arguments:

```
$ bg_kill
Warning -- no argument supplied, trying default loc: ~/pid.kill
This script DOES NOT automatically remove pid.kill file, remove it yourself!
[1]+  Terminated: 15          $1 > $parent_dir/out.log 2> $parent_dir/err.log
```

Optionally, you can specify which file contains the `pid` of the background process as such:

```
$ bg_kill "file_loc"
```

Please do note that the `pid.kill` **file is not removed** for security reasons...thus you have 
to remove it yourself.

