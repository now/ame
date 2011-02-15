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

  expect 'd' do
    Class.new(Ame::Class){
      description 'd'
      def initialize() end
    }.description
  end

  expect 'd' do
    Class.new(Ame::Class){
      description 'd'
      def a() end
    }.methods[:a].description
  end

  expect ['a', 'b'] do
    Class.new(Ame::Class){
      description 'd'
      def a() end

      description 'e'
      def b() end
    }.methods.entries.map{ |m| m.name.to_s }.sort
  end

  expect 'd' do
    Class.new(Ame::Class){
      dispatch Class.new(Ame::Class){
        basename 'a'

        description 'd'
        def initialize() end
      }
    }.methods[:a].description
  end

  expect ArgumentError do
    Class.new(Ame::Class){
      argument :a, 'd'
      dispatch Class.new(Ame::Class){
        basename 'a'

        description 'd'
        def initialize() end
      }
    }
  end
end
