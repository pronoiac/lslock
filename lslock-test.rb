#!/usr/bin/env ruby

filename = ARGV[0] || "test"

# let's avoid opening the file as writable if it exists - updates mtime
mode = (File.exists?(filename) ? "r" : "w")

file = File.open(filename, mode)

print "Acquiring lock on filename \"#{filename}\"... "
# open shared lock
file.flock(File::LOCK_SH)
puts "done."

puts "Press enter to exit and free lock."
waiting = STDIN.gets

# note: on ctrl-c, lock is freed on exit anyway.
print "Unlocking file... "
file.flock(File::LOCK_UN)
puts "done."
