# -*- coding: utf-8 -*-

Expectations do
  expect TrueClass do Ame::Types::Boolean.parse('true') end
  expect TrueClass do Ame::Types::Boolean.parse('yes') end
  expect TrueClass do Ame::Types::Boolean.parse('on') end
  expect Ame::MalformedArgument do Ame::Types::Boolean.parse('') end
  expect Ame::MalformedArgument do Ame::Types::Boolean.parse('1') end
  expect Ame::MalformedArgument do Ame::Types::Boolean.parse('junk') end

  expect FalseClass do Ame::Types::Boolean.parse('false') end
  expect FalseClass do Ame::Types::Boolean.parse('no') end
  expect FalseClass do Ame::Types::Boolean.parse('off') end
  expect Ame::MalformedArgument do Ame::Types::Boolean.parse('') end
  expect Ame::MalformedArgument do Ame::Types::Boolean.parse('0') end
  expect Ame::MalformedArgument do Ame::Types::Boolean.parse('junk') end
end
