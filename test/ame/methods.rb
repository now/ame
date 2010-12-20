# -*- coding: utf-8 -*-

Expectations do
  expect Enumerable do
    Ame::Methods.new
  end

  expect Ame::Methods.new do |o|
    o << Ame::Method.new(nil)
  end

  expect Ame::Method.new(nil) do |o|
    (Ame::Methods.new << o.define(:name))[:name]
  end

  expect Ame::Method.new(nil) do |o|
    (Ame::Methods.new << o.define(:name))['name']
  end
end
