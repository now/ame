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
    Class.new(Ame::Class).namespace :name => 'namespace'
  end

  expect 'namespace' do
    Ame::Classes.stubs :<<
    c = Class.new(Ame::Class)
    c.namespace :name => 'namespace'
    c.namespace
  end

  expect 'ame:testclass' do
    Ame::Classes.stubs :<<
    c = Class.new(Ame::Class)
    c.stubs(:name).returns('Ame::TestClass')
    c.namespace :description => 'd'
    c.namespace
  end

  expect 'd' do
    Ame::Classes.stubs :<<
    c = Class.new(Ame::Class)
    c.namespace :description => 'd'
    c.description
  end

  expect 'd' do
    Ame::Classes.stubs :<<
    c = Class.new(Ame::Class)
    c.namespace :name => 'namespace', :description => 'd'
    c.description
  end
  
  expect Ame::Method.any_instance.to.receive(:description).with('d') do
    Ame::Classes.stubs :<<
    Class.new(Ame::Class).description 'd'
  end

  expect Ame::Classes.to.receive(:<<) do
    Class.new(Ame::Class)
  end
end
