# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Ame::Action.new.to.delegate(:option).to(:options) do |action|
    action.option 'a', 'd'
  end

  expect Ame::Action.new.to.delegate(:argument).to(:arguments) do |action|
    action.argument 'a', 'd'
  end

  expect Ame::Action.new.to.delegate(:splat).to(:arguments) do |action|
    action.splat 'a', 'd'
  end

  expect Ame::Action.new.to.delegate(:arity).to(:arguments) do |action|
    action.arity
  end

  expect Ame::Action.new.not.to.be.defined?

  expect Ame::Action.new.to.be.defined? do |action|
    action.description 'd'
  end

  expect 'd' do
    Ame::Action.new.description('d').description
  end

  expect 'name' do
    action = Ame::Action.new
    action.name = 'name'
    action.name
  end

  expect [{'a' => true}, ['b', 1, true, ['d', 'e', 'f']]] do
    action = Ame::Action.new
    action.option('a', 'd')
    action.argument('a', 'd')
    action.argument('b', 'd', :type => Integer)
    action.argument('c', 'd', :type => FalseClass)
    action.splat('d', 'd')
    action.process(['b', '-a', '1', 'on', 'd', 'e', 'f'])
  end
end
