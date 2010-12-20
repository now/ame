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
end
