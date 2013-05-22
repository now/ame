# -*- coding: utf-8 -*-

Expectations do
  expect TrueClass do
    Ame::Flag.new('a', '', false, 'd').process({}, [], '--a', 'true')
  end

  expect FalseClass do
    Ame::Flag.new('a', '', false, 'd').process({}, [], '--a', 'off')
  end
end
