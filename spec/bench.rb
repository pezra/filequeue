# run via: time ruby bench.rb

load '../lib/filequeue.rb'
f = FileQueue.new 'bench.file'
10000.times { f.push "#{rand}" }
10000.times { f.pop }
File.delete 'bench.file'

# pops are O(n) slow!