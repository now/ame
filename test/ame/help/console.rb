# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect 'A B [C]' do
    Ame::Help::Console.arguments(Ame::Arguments.new.argument('a', 'd').
                                   argument('b', 'd').
                                   argument('c', 'd', :optional => true))
  end

  expect 'A B C...' do
    Ame::Help::Console.arguments(Ame::Arguments.new.argument('a', 'd').
                                   argument('b', 'd').
                                   splat('c', 'd'))
  end

  expect 'A' do
    Ame::Help::Console.argument(Ame::Argument.new('a', 'd'))
  end

  expect '[A]' do
    Ame::Help::Console.argument(Ame::Argument.new('a', 'd', :optional => true))
  end

  expect 'A...' do
    Ame::Help::Console.splat(Ame::Splat.new('a', 'd'))
  end

  expect '[A]...' do
    Ame::Help::Console.splat(Ame::Splat.new('a', 'd', :optional => true))
  end

  expect "-a, --abc=ABC  d\n    --bbc      e" do
    Ame::Help::Console.options(Ame::Options.new.option('bbc', 'e').
                                option('abc', 'd', :aliases => 'a', :type => String))
  end

  expect '-a' do
    Ame::Help::Console.option(Ame::Option.new('a', 'd'))
  end

  expect '-a, --abc' do
    Ame::Help::Console.option(Ame::Option.new('a', 'd', :aliases => 'abc'))
  end

  expect '-a, --abc' do
    Ame::Help::Console.option(Ame::Option.new('abc', 'd', :aliases => 'a'))
  end

  expect '-a, --abc' do
    Ame::Help::Console.option(Ame::Option.new('abc', 'd', :aliases => ['a', 'b', 'cde']))
  end

  expect '-a, --abc=ABC' do
    Ame::Help::Console.option(Ame::Option.new('abc', 'd', :aliases => 'a', :type => String))
  end

  expect '    --abc' do
    Ame::Help::Console.option(Ame::Option.new('abc', 'd'))
  end

  expect '    --abc=ABC' do
    Ame::Help::Console.option(Ame::Option.new('abc', 'd', :type => String))
  end
end
