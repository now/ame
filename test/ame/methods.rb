# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Enumerable do
    Ame::Methods.new
  end

  expect Ame::Methods.new do |o|
    o.expected << Ame::Method.new
  end

  expect Ame::Method.new do |o|
    o.expected.name = 'name'
    actions = Ame::Methods.new
    actions << o.expected
    actions['name']
  end

  expect [Ame::Method.new, Ame::Method.new] do |o|
    as = o.expected
    as[0].name = 'name1'
    as[1].name = 'name2'
    actions = Ame::Methods.new
    actions << as[0] << as[1]
    actions.entries
  end
end
