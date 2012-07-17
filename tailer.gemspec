# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tailer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Erik Osterman"]
  gem.email         = ["e@osterman.com"]
  gem.description   = %q{Tailer is a utility for streaming files over SSH}
  gem.summary       = %q{Tailer is a utility for streaming files over SSH}
  gem.homepage      = ""
  gem.license       = "GPL3"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tailer"
  gem.require_paths = ["lib"]
  gem.version       = Tailer::VERSION
end
