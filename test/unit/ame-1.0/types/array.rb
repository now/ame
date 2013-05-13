# -*- coding: utf-8 -*-

Expectations do
  expect Ame::Types::Array do Ame::Types::Array[String] end
  expect [''] do Ame::Types::Array[String].parse('') end
  expect [1] do Ame::Types::Array[Integer].parse('1') end
  expect [1, 2, 3] do
    ary = Ame::Types::Array[Integer]
    ary.parse('1')
    ary.parse('2')
    ary.parse('3')
  end
end
