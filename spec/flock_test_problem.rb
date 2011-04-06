# I'm not sure how to test if a file is flocked -- see 'normal' example for explanation
#
# If you open two instances of IRB, lock a file in one and run is_locked? on the
# same file in the other window it returns true as expected

require 'filequeue'

def is_locked?(file)
  status = file.flock File::LOCK_EX | File::LOCK_NB
  return status == 0 ? false : true
end

# normal
normal_file = File.open('normal_test', 'w')
normal_file.flock File::LOCK_EX # file is now locked
puts "normal: #{is_locked? normal_file}" # returns false even though file is locked
normal_file.flock File::LOCK_UN # file is now unlocked
File.delete 'normal_test'

# in block
FileQueue.new('block_test').safe_open('w') do |block_file| 
  puts "in block: #{is_locked? block_file}"
end
File.delete 'block_test'

# in fork
fork_file = File.open('fork_test', 'w')
fork_file.flock File::LOCK_EX
child = fork do
  puts "fork: #{is_locked? fork_file}"
  fork_file.flock File::LOCK_UN
  File.delete 'fork_test'
  exit
end
