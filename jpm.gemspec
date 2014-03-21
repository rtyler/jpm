# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jpm/version'

Gem::Specification.new do |gem|
  gem.name          = 'jpm'
  gem.version       = JPM::VERSION
  gem.authors       = ["R. Tyler Croy"]
  gem.email         = ['tyler@monkeypox.org']
  gem.description   = 'A Jenkins Plugin Manager'
  gem.summary       = ''
  gem.homepage      = ""
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('thor', '~> 0.18')
end
