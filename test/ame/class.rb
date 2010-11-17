# -*- coding: utf-8 -*-

Expectations do
  expect 'testclass' do
    Class.new(Ame::Class).tap{ |c| stub(c).name{ 'Ame::TestClass' } }.namespace
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
    Class.new(Class.new(Ame::Class).tap{ |c| stub(c).name{ 'Outer' } }).
      tap{ |c| stub(c).name{ 'Whatever::Inner' } }.namespace
  end

  expect 'outer inner' do
    Class.new(Class.new(Ame::Class){ namespace 'outer' }).
      tap{ |c| stub(c).name{ 'Whatever::Inner' } }.namespace
  end

  expect 'c1 c2 c3' do
    Class.new(Class.new(Class.new(Ame::Class){ namespace 'c1' }).
                tap{ |c| stub(c).name{ 'Whatever1::C2' } }).
      tap{ |c| stub(c).name{ 'Whatever2::C3' } }.namespace
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
    stub(Ame::Dispatch).new{ stub }
    Class.new(Ame::Class){
      description 'd'
      def initialize() end
    }.description
  end

  expect Ame::Help::Console.new do |o|
    Ame::Class.help = o
  end

  expect Ame::Help::Console.new.to.receive.for_dispatch(Ame::Class, :method, :subclass) do |o|
    Ame::Class.help = o
    Ame::Class.help_for_dispatch :method, :subclass
  end

  expect Ame::Help::Console.new.to.receive.for_method(Ame::Class, :method) do |o|
    Ame::Class.help = o
    Ame::Class.help_for_method :method
  end

  expect [:a, :b] do
    Class.new(Ame::Class){
      description 'd'
      def a() end

      description 'e'
      def b() end
    }.methods.entries.map{ |m| m.name }
  end

  expect Ame::Dispatch.to.receive.new(Ame::Class, arg){ stub } do |o|
    Class.new(Ame::Class){
      description 'd'
      def initialize() end
    }
  end

  expect mock.to.receive.define do |o|
    stub(Ame::Dispatch).new{ o }
    Class.new(Ame::Class){
      description 'd'
      def initialize() end
    }
  end
end
