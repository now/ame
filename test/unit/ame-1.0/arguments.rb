# -*- coding: utf-8 -*-

Expectations do
  expect Enumerable do Ame::Arguments::Undefined.new.define end

  expect Ame::MissingArgument do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').
      define.
      process({}, [])
  end

  expect [] do
    Ame::Arguments::Undefined.new.
      define.
      process({}, [])
  end

  expect [1] do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd', :type => Integer).
      define.
      process({}, %w[1])
  end

  expect [1, TrueClass] do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd', :type => Integer).
      argument(:b, 'd', :type => FalseClass).
      define.
      process({}, %w[1 true])
  end

  expect Ame::MissingArgument do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd', :type => Integer).
      splat(:b, 'd').
      define.
      process({}, %w[1])
  end

  expect [1, []] do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd', :type => Integer).
      splat(:b, 'd', :optional => true).
      define.
      process({}, %w[1])
  end

  expect [1, [2, 3]] do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd', :type => Integer).
      splat(:b, 'd', :type => Integer).
      define.
      process({}, %w[1 2 3])
  end

  expect Ame::Splat do
    Ame::Arguments::Undefined.new.
      splat(:a, 'd').
      define.
      splat
  end

  expect Ame::SuperfluousArgument do
    Ame::Arguments::Undefined.new.
      define.
      process({}, %w[1])
  end
end
