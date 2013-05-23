# -*- coding: utf-8 -*-

Expectations do
  expect nil do Ame::Optional.new(:a, nil, 'd').process({}, [], []) end
  expect 'default' do Ame::Optional.new(:a, 'default', 'd').process({}, [], []) end
  expect 2 do Ame::Optional.new(:a, 1, 'd').process({}, [], ['2']) end
  expect TrueClass do Ame::Optional.new(:a, true, 'd').process({}, [], []) end
  expect FalseClass do Ame::Optional.new(:a, false, 'd').process({}, [], []) end
end
