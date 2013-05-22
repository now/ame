# -*- coding: utf-8 -*-

Expectations do
  expect 'string' do
    Ame::Option.new('a', '', 'a', '', 'd').process({}, [], '--a', 'string')
  end

  expect 'a' do
    Ame::Option.new('a', '', 'a', '', 'd').argument_name
  end

  expect '-a' do
    Ame::Option.new('a', '', 'a', '', 'd').to_s
  end

  expect '--abc' do
    Ame::Option.new('', 'abc', 'a', '', 'd').to_s
  end
end
