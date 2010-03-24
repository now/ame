# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Ame::Argument do
    Ame::Splat.new('a', 'd')
  end
  
  expect [] do
    Ame::Splat.new('a', 'd', :optional => true).process([], [])
  end

  expect ['arg'] do
    Ame::Splat.new('a', 'd').process([], ['arg'])
  end

  expect [1, 2] do
    Ame::Splat.new('a', 'd', :type => :integer).process([], ['1', '2'])
  end

  expect 'A...' do
    Ame::Splat.new('a', 'd').to_s
  end

  expect '[A]...' do
    Ame::Splat.new('a', 'd', :optional => true).to_s
  end
end
