# -*- coding: utf-8 -*-

Expectations do
  expect 1 do Ame::Types::Integer.parse('1') end
  expect Ame::MalformedArgument do Ame::Types::Integer.parse('') end
  expect Ame::MalformedArgument do Ame::Types::Integer.parse('junk') end
end
