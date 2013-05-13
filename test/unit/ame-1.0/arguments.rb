# -*- coding: utf-8 -*-

Expectations do
  expect Enumerable do Ame::Arguments.new end

  expect 0 do
    Ame::Arguments.new.arity
  end
  expect 1 do
    Ame::Arguments.new.argument(:a, 'd').arity
  end
  expect(-1) do
    Ame::Arguments.new.argument(:a, 'd', :optional => true).arity
  end
  expect 2 do
    Ame::Arguments.new.argument(:a, 'd').argument(:b, 'd').arity
  end
  expect(-2) do
    Ame::Arguments.new.argument(:a, 'd').
                       argument(:b, 'd', :optional => true).arity
  end
  expect(-3) do
    Ame::Arguments.new.argument(:a, 'd').
                       argument(:b, 'd').
                       argument(:c, 'd', :optional => true).arity
  end
  expect(-4) do
    Ame::Arguments.new.argument(:a, 'd').
                       argument(:b, 'd').
                       splat(:c, 'd').arity
  end
  expect(-3) do
    Ame::Arguments.new.argument(:a, 'd').
                       argument(:b, 'd').
                       splat(:c, 'd', :optional => true).arity
  end
  expect(-3) do
    Ame::Arguments.new.argument(:a, 'd').
                       argument(:b, 'd').
                       argument(:c, 'd', :optional => true).
                       argument(:d, 'd', :optional => true).arity
  end
  expect(-3) do
    Ame::Arguments.new.argument(:a, 'd').splat(:b, 'd').arity
  end

  expect ArgumentError.new('argument b must come before splat argument a') do
    Ame::Arguments.new.splat(:a, 'd').argument(:b, 'd')
  end

  expect ArgumentError.new('optional argument a may not precede required argument b') do
    Ame::Arguments.new.argument(:a, 'd', :optional => true).argument(:b, 'd')
  end

  expect ArgumentError.new('splat argument a already defined: b') do
    Ame::Arguments.new.splat(:a, 'd').splat(:b, 'd')
  end

  expect ArgumentError.new('optional argument a may not precede required splat argument b') do
    Ame::Arguments.new.argument(:a, 'd', :optional => true).splat(:b, 'd')
  end

  expect Ame::MissingArgument do
    Ame::Arguments.new.argument(:a, 'd').process({}, [])
  end

  expect [] do
    Ame::Arguments.new.process({}, [])
  end

  expect [1] do
    Ame::Arguments.new.argument(:a, 'd', :type => Integer).process({}, %w[1])
  end

  expect [1, TrueClass] do
    Ame::Arguments.new.argument(:a, 'd', :type => Integer).
                       argument(:b, 'd', :type => FalseClass).
                       process({}, %w[1 true])
  end

  expect Ame::MissingArgument do
    Ame::Arguments.new.argument(:a, 'd', :type => Integer).
                       splat(:b, 'd').
                       process({}, %w[1])
  end

  expect [1, []] do
    Ame::Arguments.new.argument(:a, 'd', :type => Integer).
                       splat(:b, 'd', :optional => true).
                       process({}, %w[1])
  end

  expect [1, [2, 3]] do
    Ame::Arguments.new.argument(:a, 'd', :type => Integer).
                       splat(:b, 'd', :type => Integer).
                       process({}, %w[1 2 3])
  end

  expect Ame::Splat do
    Ame::Arguments.new.splat(:a, 'd').splat
  end

  expect Ame::SuperfluousArgument do
    Ame::Arguments.new.process({}, %w[1])
  end
end
