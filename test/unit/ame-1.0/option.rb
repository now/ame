# -*- coding: utf-8 -*-

Expectations do
  expect 'string' do
    Ame::Option.new('a', '', 'a', '', 'd').process({}, [], '--a', 'string')
  end

  expect 'A' do
    Ame::Option.new('a', '', 'a', '', 'd').argument
  end
end
