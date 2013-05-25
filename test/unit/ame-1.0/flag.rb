# -*- coding: utf-8 -*-

Expectations do
  expect ArgumentError.new('both short and long can’t be empty') do
    Ame::Flag.new('', '', false, 'd')
  end

  expect ArgumentError.new('short can’t be longer than 1: abc') do
    Ame::Flag.new('abc', '', false, 'd')
  end

  expect TrueClass do
    Ame::Flag.new('a', '', false, 'd').process({}, [], '--a', 'true')
  end

  expect FalseClass do
    Ame::Flag.new('a', '', false, 'd').process({}, [], '--a', 'off')
  end

  expect 'a' do
    Ame::Flag.new('a', '', false, 'd').name
  end

  expect 'abc' do
    Ame::Flag.new('', 'abc', false, 'd').name
  end

  expect 'abc' do
    Ame::Flag.new('a', 'abc', false, 'd').name
  end
end
