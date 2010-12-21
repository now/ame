# -*- coding: utf-8 -*-

$:.unshift File.expand_path('../lib', __FILE__)

require 'ame/version'

Gem::Specification.new do |s|
  s.name = 'ame'
  s.version = Ame::Version

  s.author = 'Nikolai Weibull'
  s.email = 'now@bitwi.se'
  s.homepage = 'http://github.com/now/ame'

  s.description = IO.read(File.expand_path('../README', __FILE__))
  s.summary = s.description[/^[[:alpha:]]+.*?\./]

  s.files = Dir['{lib,test}/**/*.rb'] + %w[README Rakefile]

  s.add_development_dependency 'lookout', '~> 2.0'
  s.add_development_dependency 'yard', '~> 0.6.0'
end
