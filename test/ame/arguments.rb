# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect 0 do
    Ame::Arguments.new.arity
  end

  expect 1 do
    Ame::Arguments.new.argument('a', 'd').arity
  end

  expect -1 do
    Ame::Arguments.new.argument('a', 'd', :optional => true).arity
  end

  expect 2 do
    Ame::Arguments.new.argument('a', 'd').argument('b', 'd').arity
  end

  expect -2 do
    Ame::Arguments.new.argument('a', 'd').
                       argument('b', 'd', :optional => true).arity
  end

  expect -3 do
    Ame::Arguments.new.argument('a', 'd').
                       argument('b', 'd').
                       argument('c', 'd', :optional => true).arity
  end

  expect -4 do
    Ame::Arguments.new.argument('a', 'd').
                       argument('b', 'd').
                       splat('c', 'd').arity
  end

  expect -3 do
    Ame::Arguments.new.argument('a', 'd').
                       argument('b', 'd').
                       splat('d', 'd', :optional => true).arity
  end

  expect -3 do
    Ame::Arguments.new.argument('a', 'd').
                       argument('b', 'd').
                       argument('c', 'd', :optional => true).
                       argument('d', 'd', :optional => true).arity
  end

  expect -3 do
    Ame::Arguments.new.argument('a', 'd').splat('b', 'd').arity
  end

  expect ArgumentError do
    Ame::Arguments.new.argument('a', 'd', :optional => true).argument('b', 'd')
  end

  expect ArgumentError do
    Ame::Arguments.new.splat('a', 'd').splat('b', 'd')
  end

  expect ArgumentError do
    Ame::Arguments.new.argument('a', 'd', :optional => true).splat('a', 'd')
  end

  expect Ame::MissingArgument do
    Ame::Arguments.new.argument('a', 'd').process({}, [])
  end

  expect [] do
    Ame::Arguments.new.process({}, [])
  end

  expect [1] do
    Ame::Arguments.new.argument('a', 'd', :type => Integer).process({}, ['1'])
  end

  expect [1, TrueClass] do
    Ame::Arguments.new.argument('a', 'd', :type => Integer).
                       argument('b', 'd', :type => FalseClass).
                       process({}, ['1', 'true'])
  end

  expect Ame::MissingArgument do
    Ame::Arguments.new.argument('a', 'd', :type => Integer).
                       splat('b', 'd').
                       process({}, ['1'])
  end

  expect [1, []] do
    Ame::Arguments.new.argument('a', 'd', :type => Integer).
                       splat('b', 'd', :optional => true).
                       process({}, ['1'])
  end

  expect [1, [2, 3]] do
    Ame::Arguments.new.argument('a', 'd', :type => Integer).
                       splat('b', 'd', :type => Integer).
                       process({}, ['1', '2', '3'])
  end
end
