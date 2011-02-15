# -*- coding: utf-8 -*-

Expectations do
  expect '' do Ame::Types::String.parse('') end
  expect 'junk' do Ame::Types::String.parse('junk') end
end
