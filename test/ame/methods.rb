# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Enumerable do
    Ame::Methods.new
  end

  expect Ame::Methods.new do |o|
    o << Ame::Method.new(nil)
  end

  expect Ame::Method.new(nil) do |o|
    o.name = :name
    (Ame::Methods.new << o)[:name]
  end

  expect Ame::Method.new(nil) do |o|
    o.name = :name
    (Ame::Methods.new << o)['name']
  end

  expect [Ame::Method.new(nil), Ame::Method.new(nil)] do |o|
    as = o
    as[0].name = :name1
    as[1].name = :name2
    (Ame::Methods.new << as[0] << as[1]).entries
  end
end
