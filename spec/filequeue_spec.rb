require 'spec_helper'

test_file = "pizza.waffle"

describe FileQueue do
  subject do
    FileQueue.new test_file
  end
  
  after :each do
    File.open(test_file, 'w') {|file| file.truncate 0 }
  end
  
  after :all do
    File.delete test_file
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
    it 'should lock files when doing IO' do
      # Expect that we lock files
      File.any_instance.should_receive(:flock).and_return(0)

      subject.push("things")
    end

    it 'should raise FileLockError if unable to acquire lock' do
      File.open(test_file).flock(File::LOCK_EX | File::LOCK_NB)
      lambda { subject.push("example") }.should raise_exception(FileQueue::FileLockError)
    end
  end
end
