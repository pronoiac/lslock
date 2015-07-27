#!/usr/bin/env ruby

dir_name = "/tmp/lslock-test"
Dir.mkdir(dir_name) unless File.directory?(dir_name)
recurse_dir_name = File.join(dir_name, "test")
# just to verify directory recursion
Dir.mkdir(recurse_dir_name) unless File.directory?(recurse_dir_name)

filenames = ["file1", "file2", "file3", "test/recursion"]
file_handles = []

filenames.each do |filename|
  filepath = File.join(dir_name, filename)

  file = File.open(filepath, "w")
  file_handles << file

  print "Acquiring lock on filename \"#{filename}\"... "
  # open shared lock
  file.flock(File::LOCK_SH)
  puts "done."
end # locking all filenames

puts("\nThis should list locks:\n\n")

system("./lslock.rb /tmp/lslock-test")

puts "\nPress enter to exit and free locks."
waiting = STDIN.gets

print "Unlocking files... "
file_handles.each do |file|
  # note: on ctrl-c, lock is freed on exit anyway.
  file.flock(File::LOCK_UN)
end
puts "done. Bye!"
