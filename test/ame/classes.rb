# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Enumerable do
    Ame::Classes
  end

  expect ArgumentError do
    Ame::Classes.method("", ignore)
  end

  expect ArgumentError do
    Ame::Classes.method('undefined:namespace', ignore)
  end

  expect ArgumentError do
    c = Class.new(Ame::Class)
    c.class_eval do
      namespace 'defined:namespace'
    end
    Ame::Classes.method('defined:namespace:undefined-method', ignore)
  end

  expect 'd' do
    c = Class.new(Ame::Class)
    c.class_eval do
      namespace 'defined:namespace2'
      description 'd'
      def a() end
    end
    Ame::Classes.method('defined:namespace2:a', ignore).description
  end

  expect 'd' do
    c = Class.new(Ame::Class)
    c.class_eval do
      namespace 'defined:namespace3'
      description 'd'
      def defined_method() end
    end
    Ame::Classes.method('defined:namespace3:defined-method', ignore).description
  end

  expect mock.to.receive(:methods).returns(stub(:[] => ignore)) do |o|
    Ame::Classes.method('defined-method', o)
  end
end
