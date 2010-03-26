# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Enumerable do
    Ame::Actions.new
  end

  expect Ame::Actions.new do |o|
    o.expected << Ame::Action.new
  end

  expect Ame::Action.new do |o|
    o.expected.name = 'name'
    actions = Ame::Actions.new
    actions << o.expected
    actions['name']
  end

  expect [Ame::Action.new, Ame::Action.new] do |o|
    as = o.expected
    as[0].name = 'name1'
    as[1].name = 'name2'
    actions = Ame::Actions.new
    actions << as[0] << as[1]
    actions.entries
  end
end
