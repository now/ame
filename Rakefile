$:.unshift File.expand_path("../lib", __FILE__)

require 'rake/gempackagetask'
require 'rake/testtask'
require 'rubygems/dependency_installer'
require 'yard'

require 'ame/version'

task :default => :test

specification = Gem::Specification.new do |s|
  s.name   = 'ame'
  s.summary = 'A simple command-line parser and build system'
  s.version = Ame::Version
  s.author = 'Nikolai Weibull'
  s.email = 'now@bitwi.se'
  s.homepage = 'http://github.com/now/ame'
  s.description = <<EOD
Ame is a simple command-line parser and build system.  Its aim is to replace
the need for other command-line parsers and Rake.
EOD

  s.files = FileList['{lib,test}/**/*.rb', '[A-Z]*$']

  s.add_development_dependency 'lookout', '>= 1.3.0'
  s.add_development_dependency 'yard', '>= 0.2.3.5'
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*.rb'
end

YARD::Rake::YardocTask.new

Rake::GemPackageTask.new(specification) do |g|
  desc 'Run :package and install the resulting gem'
  task :install => :package do
    Gem::DependencyInstaller.new.install File.join(g.package_dir, g.gem_file)
  end
end
