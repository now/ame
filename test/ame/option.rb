# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Ame::Argument do
    Ame::Option.new('a', 'd')
  end

  expect TrueClass do
    Ame::Option.new('a', 'd').process([], 'true')
  end

  expect FalseClass do
    Ame::Option.new('a', 'd').process([], 'off')
  end

  expect 'string' do
    Ame::Option.new('a', 'd', :type => :string).process([], 'string')
  end

  expect Ame::Option.new('a', 'd').to.be.optional?

  expect 'a' do
    Ame::Option.new('a', 'd').to_s
  end
end
