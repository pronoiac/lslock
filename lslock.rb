#!/usr/bin/env ruby

# read /proc/locks
lockfilename = "/proc/locks"

if !File.exists?(lockfilename)
  puts "Error: #{lockfilename} doesn't exist! Exiting."
  exit
end

locks = Hash.new{|hash, key| hash[key] = Array.new}

File.open(lockfilename).each_line do |line|
  # e.g. 1: POSIX  ADVISORY  WRITE 3568 fd:00:2531452 0 EOF 
  lock_num, lock_class, lock_exclusive, lock_readwrite, lock_pid, lock_id, lock_start, lock_end = line.split(" ")
  lock_major, lock_minor, lock_inode = lock_id.split(":")
  locks[lock_inode.to_i] << [lock_pid.to_i] # array of pid, allows for mult locks per file
end

#p locks

# do a depth-first search / DFS on the dir spec on cmd line

