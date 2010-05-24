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

  expect 'A' do
    Ame::Option.new('a', 'd', :type => String).argument_name
  end

  expect 'B' do
    Ame::Option.new('a', 'd', :argument => 'b', :type => String).argument_name
  end

  expect ArgumentError do
    Ame::Option.new('a', 'd', :argument => 'a').argument_name
  end

  expect ['a'] do
    Ame::Option.new('a', 'd', :aliases => 'a').aliases
  end

  expect ['a', 'b', 'c'] do
    Ame::Option.new('a', 'd', :aliases => ['a', 'b', 'c']).aliases
  end

  expect ['b', 'c', 'd'] do
    Ame::Option.new('a', 'd', :alias => 'b', :aliases => ['c', 'd']).aliases
  end

  expect '-a' do
    Ame::Option.new('a', 'd').to_s
  end

  expect '--abc' do
    Ame::Option.new('abc', 'd').to_s
  end

  expect 'a' do
    Ame::Option.new('abc', 'd', :aliases => ['a', 'b']).short
  end

  expect 'abc' do
    Ame::Option.new('a', 'd', :aliases => ['abc', 'b']).long
  end
end
