# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Enumerable do
    Ame::Methods.new
  end

  expect Ame::Methods.new do |o|
    o.expected << Ame::Method.new(nil)
  end

  expect Ame::Method.new(nil) do |o|
    o.expected.name = :name
    methods = Ame::Methods.new
    methods << o.expected
    methods[:name]
  end

  expect [Ame::Method.new(nil), Ame::Method.new(nil)] do |o|
    as = o.expected
    as[0].name = :name1
    as[1].name = :name2
    methods = Ame::Methods.new
    methods << as[0] << as[1]
    methods.entries
  end
end
