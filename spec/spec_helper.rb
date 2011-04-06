require 'rubygems'
require 'rspec'
require 'rspec/autorun'
require 'filequeue'

class File
  def flocked? &block
    status = flock LOCK_EX | LOCK_NB
    case status
      when false
        return true 
      when 0
        begin
          block ? block.call : false
        ensure
          flock LOCK_UN
        end
      else
        raise SystemCallError, status 
    end
  end
end