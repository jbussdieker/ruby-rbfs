# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbfs/version'

Gem::Specification.new do |spec|
  spec.name          = "rbfs"
  spec.version       = Rbfs::VERSION
  spec.authors       = ["Joshua Bussdieker"]
  spec.email         = ["jbussdieker@gmail.com"]
  spec.description   = %q{Ruby File Sync}
  spec.summary       = %q{Ruby File Sync}
  spec.homepage      = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rsync", "~> 0.0"
  spec.add_dependency "hosts_file", "~> 0.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
