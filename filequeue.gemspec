
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "filequeue/version"

Gem::Specification.new do |spec|
  spec.name          = "filequeue"
  spec.version       = Filequeue::VERSION
  spec.authors       = ["Peter Williams", "Max Ogden", "daddz"]
  spec.email         = ["pezra@barelyenough.org"]

  spec.summary       = "Simple file based queue"
  spec.description   = "File based queue for coordinating multiple processes."
  spec.homepage      = "https://github.com/pezra/filequeue"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
