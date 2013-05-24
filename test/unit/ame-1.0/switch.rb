# -*- coding: utf-8 -*-

Expectations do
  expect 'shallow' do
    Ame::Switch.new('', 'thread', 'style', nil, 'shallow', 'd').process({}, [], '--thread', nil)
  end

  expect 'deep' do
    Ame::Switch.new('', 'thread', 'style', nil, 'shallow', 'd').process({}, [], '--thread', 'deep')
  end

  expect :deep do
    Ame::Switch.new('', 'thread', 'style', nil, Ame::Types::Enumeration[:shallow, :deep], 'd').process({}, [], '--thread', 'deep')
  end
end
