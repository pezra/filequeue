require 'spec_helper'
require 'fileutils'
require 'timeout'

test_file = "pizza.waffle"

describe FileQueue do
  subject do
    FileQueue.new test_file, lock_timeout: lock_timeout_sec
  end

  describe '#initialize' do
    it 'should have a file name and default delimiter' do
      subject.file_name.should == test_file
      subject.delimiter.should == "\n"
    end

    it 'should let you specify your own queue delimiter' do
      FileQueue.new(test_file, ",").delimiter.should == ","
    end
  end

  describe '#push' do
    it 'should add an entry to the queue' do
      subject.push "bacon"
      File.open(test_file, 'r').read.should == "bacon\n"
    end

    it 'should add multiple entries to the queue' do
      subject.push "cats"
      subject.push "are awesome"
      File.open(test_file, 'r').read.should == "cats\nare awesome\n"
    end

    it 'should use the delimiter to separate entries in the queue' do
      FileQueue.new(test_file, ",").push "jello"
      File.open(test_file, 'r').read.should == "jello,"
    end

    it 'should raise if your object contains the delimiter' do
      lambda { subject.push "yee\nhaw" }.should raise_error(StandardError, "Queue objects cannot contain the queue delimiter")
    end

    it 'should let you use the << syntax to add things to the queue' do
      subject << "angle brackets!"
      subject.pop.should == "angle brackets!"
    end

    it 'is thread-safe' do
      num_messages = 10
      expected_messages = num_messages.times.map{|i| "msg #{i}" }

      expected_messages
        .map{|msg| Thread.new{ Thread.pass; subject.push(msg) } }
        .each(&:join)

      actual_messages = num_messages.times.map{ subject.pop }
      actual_messages.should match_array(expected_messages)
    end

    it 'raises FileLockError within after lock timeout duration if file is locked' do
      Timeout::timeout(lock_timeout_sec * 2) do
        File.open(test_file, 'r') do |f|
          f.flock(File::LOCK_NB|File::LOCK_EX)

          ->(){
            ->(){ subject.push("test") }.should raise_error(FileQueue::FileLockError)
          }.should complete_within(lock_timeout_sec * 1.1)
        end
      end
    end

  end

  describe '#pop' do
    it 'should retrieve an item from the queue' do
      subject.push "important document"
      subject.pop.should == "important document"
    end

    it 'should return the oldest item in the queue' do
      subject.push "old thing"
      subject.push "new thing"
      subject.pop.should == "old thing"
    end

    it 'should return nil if the queue is empty' do
      subject.pop.should be_nil
    end

    it 'is thread-safe' do
      num_messages = 10
      expected_messages = num_messages.times.map{|i| "msg #{i}" }
      expected_messages.each{|msg| subject.push(msg) }

      actual_messages =
        num_messages
        .times
        .map{ Thread.new { Thread.pass; subject.pop } }
        .map(&:join)
        .map(&:value)

      actual_messages.should match_array(expected_messages)
    end

    it 'raises FileLockError after lock timeout duration if file is locked' do
      Timeout::timeout(lock_timeout_sec * 2) do
        File.open(test_file, 'r') do |f|
          f.flock(File::LOCK_NB|File::LOCK_EX)

          ->(){
            ->(){ subject.pop }.should raise_error(FileQueue::FileLockError)
          }.should complete_within(lock_timeout_sec * 1.1)
        end
      end
    end
  end

  describe '#length' do
    it 'should tell you the size of the queue' do
      subject.length.should == 0
      subject.push "content"
      subject.length.should == 1
    end
  end

  describe '#empty' do
    it 'should tell you if the queue is empty or not' do
      subject.empty?.should be true
      subject.push "content"
      subject.empty?.should be false
    end
  end

  describe '#clear' do
    it 'should empty the queue' do
      subject.push "content"
      subject.clear
      subject.empty?.should be true
    end
  end

  describe '#safe_open' do
    skip 'should lock files when doing IO (implemented, but cannot test)' do
      # After reading the definition of File#flock more closely (http://www.ruby-doc.org/core/classes/File.html#M000040) I'm realizing that the LOCK_EX is process wide and won't block access to anything inside the current process. This means that in the same process that you lock a file in you will not be blocked from that file, so in a test you can't simulate what it is like to be blocked access without spawning a new process.
      # From what I can tell 1.8.7 can't really spawn new processes. 1.9.2 has Process#spawn which in theory would allow the testing of the flocking LOCK_EX block but I have not tested it.
    end
  end

  # background

  let(:lock_timeout_sec) { 0.1 }

  after :each do
    File.open(test_file, 'w') {|file| file.truncate 0 }
  end

  after :all do
    File.delete test_file
  end

  matcher :complete_within do |expected_sec|
    match do |block|
      started_at = Time.now
      block.call
      (Time.now - started_at).should be < expected_sec
    end
  end
end
