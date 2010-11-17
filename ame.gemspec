# -*- coding: utf-8 -*-

$:.unshift File.expand_path("../lib", __FILE__)

require 'ame/version'

Gem::Specification.new do |s|
  s.name = 'ame'
  s.version = Ame::Version

  s.author = 'Nikolai Weibull'
  s.email = 'now@bitwi.se'
  s.homepage = 'http://github.com/now/ame'

  s.summary = 'A simple command-line parser and build system'
  s.description = <<EOD
Ame is a simple command-line parser and build system.  Its aim is to replace
the need for other command-line parsers and Rake.
EOD

  s.files = Dir['{lib,test}/**/*.rb,[A-Z]*$']

  s.add_development_dependency 'lookout', '~> 2.0'
  s.add_development_dependency 'yard', '~> 0.6.0'
end
