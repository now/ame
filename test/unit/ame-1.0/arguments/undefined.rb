# -*- coding: utf-8 -*-

Expectations do
  expect 0 do
    Ame::Arguments::Undefined.new.arity
  end
  expect 1 do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').arity
  end
  expect(-1) do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd', :optional => true).arity
  end
  expect 2 do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').argument(:b, 'd').arity
  end
  expect(-2) do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').
      argument(:b, 'd', :optional => true).arity
  end
  expect(-3) do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').
      argument(:b, 'd').
      argument(:c, 'd', :optional => true).arity
  end
  expect(-4) do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').
      argument(:b, 'd').
      splat(:c, 'd').arity
  end
  expect(-3) do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').
      argument(:b, 'd').
      splat(:c, 'd', :optional => true).arity
  end
  expect(-3) do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').
      argument(:b, 'd').
      argument(:c, 'd', :optional => true).
      argument(:d, 'd', :optional => true).arity
  end
  expect(-3) do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd').
      splat(:b, 'd').arity
  end

  expect ArgumentError.new('argument b must come before splat argument a') do
    Ame::Arguments::Undefined.new.
      splat(:a, 'd').
      argument(:b, 'd')
  end

  expect ArgumentError.new('optional argument a may not precede required argument b') do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd', :optional => true).
      argument(:b, 'd')
  end

  expect ArgumentError.new('splat argument a already defined: b') do
    Ame::Arguments::Undefined.new.
      splat(:a, 'd').
      splat(:b, 'd')
  end

  expect ArgumentError.new('optional argument a may not precede required splat argument b') do
    Ame::Arguments::Undefined.new.
      argument(:a, 'd', :optional => true).
      splat(:b, 'd')
  end

  expect Ame::Splat do
    Ame::Arguments::Undefined.new.
      splat(:a, 'd').splat
  end
end
