# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect 'testclass' do
    c = Class.new(Ame::Class)
    c.stubs(:name).returns('Ame::TestClass')
    c.namespace
  end

  expect 'namespace' do
    Class.new(Ame::Class).namespace 'namespace'
  end

  expect 'namespace' do
    Class.new(Ame::Class){ namespace 'namespace' }.namespace
  end

  expect ArgumentError do
    Class.new(Class.new(Ame::Class)).namespace 'namespace'
  end

  expect 'outer inner' do
    c = Class.new(Ame::Class)
    c.stubs(:name).returns("Outer")
    d = Class.new(c)
    d.stubs(:name).returns('Whatever::Inner')
    d.namespace
  end

  expect 'outer inner' do
    c = Class.new(Ame::Class){ namespace 'outer' }
    d = Class.new(c)
    d.stubs(:name).returns('Whatever::Inner')
    d.namespace
  end

  expect 'c1 c2 c3' do
    c = Class.new(Ame::Class){ namespace 'c1' }
    d = Class.new(c)
    d.stubs(:name).returns('Whatever1::C2')
    e = Class.new(d)
    e.stubs(:name).returns('Whatever2::C3')
    e.namespace
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

  expect 'd' do
    Class.new(Ame::Class){
      description 'd'
      def initialize() end
    }.description
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
