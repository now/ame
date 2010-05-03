# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect 'ame:testclass' do
    c = Class.new(Ame::Class)
    c.stubs(:name).returns('Ame::TestClass')
    c.namespace
  end

  expect 'namespace' do
    Class.new(Ame::Class).namespace :name => 'namespace'
  end

  expect 'namespace' do
    c = Class.new(Ame::Class)
    c.namespace :name => 'namespace'
    c.namespace
  end

  expect 'ame:testclass' do
    c = Class.new(Ame::Class)
    c.stubs(:name).returns('Ame::TestClass')
    c.namespace :description => 'd'
    c.namespace
  end

  expect 'd' do
    c = Class.new(Ame::Class)
    c.namespace :description => 'd'
    c.description
  end

  expect 'd' do
    c = Class.new(Ame::Class)
    c.namespace :name => 'namespace', :description => 'd'
    c.description
  end
  
  expect Class.new(Ame::Class).to.delegate(:description).to(:method) do |o|
    o.description 'd'
  end

  expect Class.new(Ame::Class).to.delegate(:options_must_precede_arguments).to(:method) do |o|
    o.options_must_precede_arguments
  end

  expect Class.new(Ame::Class).to.delegate(:option).to(:method) do |o|
    o.option 'a', 'd'
  end

  expect Class.new(Ame::Class).to.delegate(:argument).to(:method) do |o|
    o.argument 'a', 'd'
  end

  expect Class.new(Ame::Class).to.delegate(:splat).to(:method) do |o|
    o.splat 'a', 'd'
  end

  expect [:a, :b] do
    Class.new(Ame::Class){
      description 'd'
      def a() end

      description 'e'
      def b() end
    }.methods.entries.map{ |m| m.name }
  end
end
