filename = "test"

# let's avoid opening the file as writable if it exists - updates mtime
if File.exists?(filename)
  # open as readonly
  mode = "r"
else
  # create file
  mode = "w"
end
mode = "w"
file = File.open(filename, mode)

print "Acquiring lock... "
# open shared lock
file.flock(File::LOCK_SH)
puts "done."

puts "Press enter to exit and free lock."
waiting = gets

# note: on ctrl-c, lock is freed on exit anyway.
print "Unlocking file... "
file.flock(File::LOCK_UN)
puts "done."
