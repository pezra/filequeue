require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "filequeue"
    gem.summary = %Q{A simple file based queue in Ruby}
    gem.description = %Q{A simple file based queue in Ruby}
    gem.email = "max@maxogden.com"
    gem.homepage = "http://github.com/maxogden/filequeue"
    gem.authors = ["Max Ogden", "daddz"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec