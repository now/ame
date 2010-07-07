# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect 'testclass' do
    Ame::Class.stubs(:inherited)
    Class.new(Ame::Class){
      stubs(:name).returns('Ame::TestClass')
    }.namespace
  end

  expect 'namespace' do
    Ame::Class.stubs(:inherited)
    Class.new(Ame::Class).namespace 'namespace'
  end

  expect 'namespace' do
    Ame::Class.stubs(:inherited)
    Class.new(Ame::Class){ namespace 'namespace' }.namespace
  end

  expect ArgumentError do
    Ame::Class.stubs(:inherited)
    c = Class.new(Ame::Class)
    c.stubs(:inherited)
    Class.new(c).namespace 'namespace'
  end

  expect 'outer inner' do
    Ame::Class.stubs(:inherited)
    c = Class.new(Ame::Class)
    c.stubs(:name).returns("Outer")
    c.stubs(:inherited)
    d = Class.new(c)
    d.stubs(:name).returns('Whatever::Inner')
    d.namespace
  end

  expect 'outer inner' do
    Ame::Class.stubs(:inherited)
    c = Class.new(Ame::Class){ namespace 'outer' }
    c.stubs(:inherited)
    d = Class.new(c)
    d.stubs(:name).returns('Whatever::Inner')
    d.namespace
  end

  expect 'c1 c2 c3' do
    Ame::Class.stubs(:inherited)
    c = Class.new(Ame::Class){ namespace 'c1' }
    c.stubs(:inherited)
    d = Class.new(c)
    d.stubs(:name).returns('Whatever1::C2')
    d.stubs(:inherited)
    e = Class.new(d)
    e.stubs(:name).returns('Whatever2::C3')
    e.namespace
  end

=begin
  expect Ame::Class.to.delegate(:description).to(:method) do |o|
    o.description 'd'
  end

  expect Ame::Class.to.delegate(:options_must_precede_arguments).to(:method) do |o|
    o.options_must_precede_arguments
  end

  expect Ame::Class.to.delegate(:option).to(:method) do |o|
    o.option 'a', 'd'
  end

  expect Ame::Class.to.delegate(:argument).to(:method) do |o|
    o.argument 'a', 'd'
  end

  expect Ame::Class.to.delegate(:splat).to(:method) do |o|
    o.splat 'a', 'd'
  end
=end

  expect 'd' do
    Ame::Dispatch.stubs(:new).returns(ignore)
    Class.new(Ame::Class){
      description 'd'
      def initialize() end
    }.description
  end

  expect Ame::Help::Console.new do |o|
    Ame::Class.help = o.expected
  end

  expect Ame::Help::Console.new.to.receive(:for_dispatch).with(Ame::Class, :method, :subclass) do |o|
    Ame::Class.help = o
    Ame::Class.help_for_dispatch :method, :subclass
  end

  expect Ame::Help::Console.new.to.receive(:for_method).with(Ame::Class, :method) do |o|
    Ame::Class.help = o
    Ame::Class.help_for_method :method
  end

  expect [:a, :b] do
    Ame::Class.stubs(:inherited)
    Class.new(Ame::Class){
      description 'd'
      def a() end

      description 'e'
      def b() end
    }.methods.entries.map{ |m| m.name }
  end

  expect Ame::Dispatch.to.receive(:new).with(Ame::Class, anything).returns(ignore) do |o|
    Class.new(Ame::Class){
      description 'd'
      def initialize() end
    }
  end

  expect Ame::Dispatch.any_instance.to.receive(:define) do |o|
    Class.new(Ame::Class){
      description 'd'
      def initialize() end
    }
  end
end
