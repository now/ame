# -*- coding: utf-8 -*-

Expectations do
  expect Enumerable do Ame::Arguments::Undefined.new.define end

  expect Ame::MissingArgument do
    Ame::Arguments::Undefined.new.
      argument('a', String, 'd').
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
      argument('a', Integer, 'd').
      define.
      process({}, %w[1])
  end

  expect [1, TrueClass] do
    Ame::Arguments::Undefined.new.
      argument('a', Integer, 'd').
      argument('b', FalseClass, 'd').
      define.
      process({}, %w[1 true])
  end

  expect Ame::MissingArgument do
    Ame::Arguments::Undefined.new.
      argument('a', 'd', :type => Integer).
      splus('b', String, 'd').
      define.
      process({}, %w[1])
  end

  expect [1, []] do
    Ame::Arguments::Undefined.new.
      argument('a', Integer, 'd').
      splat('b', String, 'd').
      define.
      process({}, %w[1])
  end

  expect [1, [2, 3]] do
    Ame::Arguments::Undefined.new.
      argument('a', Integer, 'd').
      splus('b', Integer, 'd').
      define.
      process({}, %w[1 2 3])
  end

  expect Ame::SuperfluousArgument do
    Ame::Arguments::Undefined.new.
      define.
      process({}, %w[1])
  end
end
