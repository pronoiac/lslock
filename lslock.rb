#!/usr/bin/env ruby

dirname = ARGV[0] || "./"

# read /proc/locks
lockfilename = "/proc/locks"
locked_files = {}
seen_dirs = {}

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

# p locks

# do a depth-first search / DFS on the dir spec on cmd line
def recurse(dir, locks, locked_files)
  Dir.chdir(dir)
  current_dir = Dir.pwd
  Dir.foreach(".") do |entry|
    #puts entry
    inode = File.stat(entry).ino
    #p inode
    if locks.has_key?(inode)
      locked_files[inode] = File.join(current_dir, entry)
      puts "match: #{inode} - #{entry}"
    end # /locks.has_key?
  end # /Dir.foreach
end # /recurse

recurse(dirname, locks, locked_files)
#p locks
#p locked_files
