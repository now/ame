# -*- coding: utf-8 -*-

Expectations do
  expect Enumerable do Ame::Methods.new end

  expect Ame::Methods.new do |o| o << Ame::Method::Undefined.new(nil).define(:name) end

  expect Ame::Method::Undefined.new(nil).define(:name) do |o| (Ame::Methods.new << o)['name'] end
end
