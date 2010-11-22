# -*- coding: utf-8 -*-

Expectations do
  expect 'test-class' do
    Class.new(Ame::Class).tap{ |c| stub(c).name{ 'Ame::TestClass' } }.basename
  end

  expect 'namespace' do
    Class.new(Ame::Class).basename 'namespace'
  end

  expect 'namespace' do
    Class.new(Ame::Class){ basename 'namespace' }.basename
  end

  expect 'outer inner' do
    parent = Class.new(Ame::Class) {
      self.parent = Class.new(Ame::Root)
    }.tap{ |c| stub(c).name{ 'Outer' } }
    Class.new(Ame::Class){
      self.parent = parent
    }.tap{ |c| stub(c).name{ 'Outer::Inner' } }.fullname
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

  expect [:a, :b] do
    Class.new(Ame::Class){
      description 'd'
      def a() end

      description 'e'
      def b() end
    }.methods.entries.map{ |m| m.name }
  end
end
