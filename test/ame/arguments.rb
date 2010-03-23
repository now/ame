# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect 0 do
    Ame::Arguments.new.count
  end

  expect 1 do
    Ame::Arguments.new.argument('a', 'd').count
  end

  expect 2 do
    Ame::Arguments.new.argument('a', 'd').argument('b', 'd').count
  end

  expect ArgumentError do
    Ame::Arguments.new.argument('a', 'd', :optional => true).argument('b', 'd')
  end

  expect Ame::Splat.to.receive(:new).with('a', 'd', {}) do
    Ame::Arguments.new.splat('a', 'd')
  end

  expect ArgumentError do
    Ame::Arguments.new.splat('a', 'd').splat('b', 'd')
  end
end
