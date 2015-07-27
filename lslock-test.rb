#!/usr/bin/env ruby

dir_name = "/tmp/lslock-test"
Dir.mkdir(dir_name)
filenames = ["file1", "file2", "file3"]

filenames.each do |filename|
  # let's avoid opening the file as writable if it exists - updates mtime
  mode = (File.exists?(filename) ? "r" : "w")

  file = File.open(filename, mode)

  print "Acquiring lock on filename \"#{filename}\"... "
  # open shared lock
  file.flock(File::LOCK_SH)
  puts "done."
end # locking all filenames


puts "Press enter to exit and free lock."
waiting = STDIN.gets

filenames.each do |filename|
  # note: on ctrl-c, lock is freed on exit anyway.
  print "Unlocking file... "
  file.flock(File::LOCK_UN)
  puts "done."
end
