# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: filequeue 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "filequeue".freeze
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Peter Williams".freeze, "Max Ogden".freeze, "daddz".freeze]
  s.date = "2018-07-31"
  s.description = "A simple file based queue in Ruby".freeze
  s.email = "pezra@barelyenough.org".freeze
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".gemtest",
    ".rspec",
    ".ruby-version",
    ".travis.yml",
    "Gemfile",
    "Gemfile.ci",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "filequeue.gemspec",
    "lib/filequeue.rb",
    "spec/bench.rb",
    "spec/filequeue_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/maxogden/filequeue".freeze
  s.rubygems_version = "2.6.13".freeze
  s.summary = "A simple file based queue in Ruby".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<filequeue>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.3"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<filequeue>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.3"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<filequeue>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.3"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end

