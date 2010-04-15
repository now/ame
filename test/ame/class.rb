# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Ame::Base::ClassMethods do
    Ame::Class
  end

  expect Ame::Base do
    Ame::Class.instance
  end

  expect 'ame:testclass' do
    Ame::Classes.stubs :<<
    c = Class.new(Ame::Class)
    c.stubs(:name).returns('Ame::TestClass')
    c.namespace
  end

  expect 'namespace' do
    Ame::Classes.stubs :<<
    Class.new(Ame::Class).namespace 'namespace'
  end

  expect 'namespace' do
    Ame::Classes.stubs :<<
    c = Class.new(Ame::Class)
    c.namespace 'namespace'
    c.namespace
  end

  expect Ame::Classes.to.receive(:<<) do
    Class.new(Ame::Class)
  end
end
