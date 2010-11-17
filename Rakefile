# -*- coding: utf-8 -*-

require 'lookout/rake/tasks/test'
require 'rake/gempackagetask'
require 'rubygems/dependency_installer'
require 'yard'

spec = Gem::Specification.load(File.expand_path('../ame.gemspec', __FILE__))

task :default => :test

Lookout::Rake::Tasks::Test.new(spec)

YARD::Rake::YardocTask.new

Rake::GemPackageTask.new(spec) do |g|
  desc 'Run :package and install the resulting gem'
  task :install => :package do
    Gem::DependencyInstaller.new.install File.join(g.package_dir, g.gem_file)
  end
end
