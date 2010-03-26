# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Ame::Argument do
    Ame::Option.new('a', 'd')
  end

  expect ArgumentError do
    Ame::Option.new('a', 'd', :type => String, :optional => true)
  end

  expect Ame::Option.new('a', 'd').to.be.optional?

  expect Ame::Option.new('a', 'd', :type => String).not.to.be.optional?

  expect FalseClass do
    Ame::Option.new('a', 'd').default
  end

  expect TrueClass do
    Ame::Option.new('a', 'd').process({}, [], 'true')
  end

  expect FalseClass do
    Ame::Option.new('a', 'd').process({}, [], 'off')
  end

  expect 'string' do
    Ame::Option.new('a', 'd', :type => String).process({}, [], 'string')
  end

  expect 'a' do
    Ame::Option.new('a', 'd').to_s
  end
end
