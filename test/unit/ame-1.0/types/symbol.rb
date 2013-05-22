# -*- coding: utf-8 -*-

Expectations do
  expect :'' do Ame::Types::Symbol.parse('') end
  expect :'junk' do Ame::Types::Symbol.parse('junk') end
end
