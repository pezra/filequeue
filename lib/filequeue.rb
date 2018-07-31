require 'timeout'

class FileQueue
  attr_accessor :file_name, :delimiter, :lock_timeout

  def initialize(file_name, delimiter="\n", lock_timeout: 10)
    @delimiter = delimiter
    @file_name = file_name
    @lock_timeout = lock_timeout
  end

  def push(obj)
    if obj.match Regexp.new @delimiter
      raise "Queue objects cannot contain the queue delimiter"
    end
    safe_open 'a' do |file|
      file.write(obj + @delimiter)
    end
  end

  alias << push

  def pop
    value = nil
    safe_open 'r+' do |file|
      value = file.gets @delimiter
      rest = file.read
      file.rewind
      file.truncate(0)
      file.write(rest)
    end
    value ? value[0..-(@delimiter.length) - 1] : nil
  end

  def length
    count = 0
    unless(File.exist?(@file_name))
      return 0
    end
    safe_open 'r' do |file|
      count = file.read.count @delimiter
    end
    count
  end

  def empty?
    return length == 0
  end

  def clear
    safe_open 'w' do |file| end
  end

  protected

  def safe_open(mode)
    File.open(@file_name, mode) do |file|
      lock file
      yield file
    end
  end

  DELAY_RANGE = (0..0.01).freeze

  # Locks the queue file for exclusive access. This will gives up
  # after `lock_timeout` seconds.
  #
  # Raises `FileLockError` if unable to acquire a lock.
  #
  # Return is undefined.
  def lock(file)
    deadline = (Time.now + lock_timeout)

    until Time.now >= deadline || lock_acquired = file.flock(File::LOCK_NB|File::LOCK_EX)
      sleep(rand(DELAY_RANGE))
    end

    (raise FileLockError, "Queue file appears to be permanently locked") unless lock_acquired
  end

  FileLockError = Class.new(Timeout::Error)
end
