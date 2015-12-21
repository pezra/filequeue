require 'rubygems'
require 'rspec'
require 'filequeue'

RSpec.configure do |c|
  c.expect_with(:rspec) { |c| c.syntax = :should }
end
