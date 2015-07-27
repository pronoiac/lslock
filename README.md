lslock
======

About
-----
It can be hard to coordinate multiple programs on a Linux system. One way to make sure that different processes don't step on each others' toes is by declaring locks on specified files, using the flock syscall. If you're troubleshooting, it isn't necessarily straightforward to figure out what locked a certain file, and `lslock` can help. 

On Linux systems, there's a "file," `/proc/locks`, which shows the necessary details; amongst other details, it shows the process ID and the inode for the file. Finding the inode isn't easy; there's no index for this, so you have to traverse the filesystem. `lslock` does this. 


How to run
----------
Given a directory, `lslock` (directory) will go through all the files and all the subdirectories, and find the files with the specified inodes. It defaults to the current directory.

`lslock-test` interactively tests `lslock`; it makes a few files and folders, runs `lslock` to see what it finds. It pauses to allow scrutiny, then removes the locks and exits. 

`flocker` locks one file and waits. It was useful for debugging. 


Misc
----
If you want to examine the inode for a specific file, try `ls -i` on the file. 

If you're only trying to avoid running the same process twice, you could emit the process id into a specified lock file, e.g. `/var/lock/aptitude`. 

This is not necessarily useful; this was done as part of a coding challenge. It was educational. 
