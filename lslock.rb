#!/usr/bin/env ruby

dirname = ARGV[0] || "./"

# read /proc/locks
lockfilename = "/proc/locks"
@locked_files = {}

if !File.exists?(lockfilename)
  puts "Error: #{lockfilename} doesn't exist! Exiting."
  exit
end

@locks = Hash.new{|hash, key| hash[key] = Array.new}

File.open(lockfilename).each_line do |line|
  # e.g. 1: POSIX  ADVISORY  WRITE 3568 fd:00:2531452 0 EOF 
  lock_num, lock_class, lock_exclusive, lock_readwrite, lock_pid, lock_id, lock_start, lock_end = line.split(" ")
  lock_major, lock_minor, lock_inode = lock_id.split(":")
  @locks[lock_inode.to_i] << [lock_pid.to_i] # array of pid, allows for mult locks per file
end


# do a depth-first search / DFS on the dir spec on cmd line
def recurse(dir)
  Dir.foreach(dir) do |entry|
    filepath = File.join(dir, entry)
    next if entry == "." or entry == ".."
    inode = File.stat(filepath).ino
    if @locks.has_key?(inode)
      @locked_files[inode] = filepath #File.join(current_dir, entry)
    end # /locks.has_key?
    if File.directory?(filepath)
      recurse(filepath)
    end # /directory?
  end # /Dir.foreach
end # /recurse

recurse(dirname)

puts "# pid(s)\tfilename"
@locked_files.each_pair { |inode, filepath|
  print @locks[inode].join(",")
  puts "\t#{filepath}"
}
