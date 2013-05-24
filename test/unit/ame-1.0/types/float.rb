# -*- coding: utf-8 -*-

Expectations do
  expect 0.1 do Ame::Types::Float.parse('0.1') end
  expect Ame::MalformedArgument do Ame::Types::Float.parse('') end
  expect Ame::MalformedArgument do Ame::Types::Float.parse('junk') end
end
