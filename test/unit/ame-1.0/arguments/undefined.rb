# -*- coding: utf-8 -*-

Expectations do
  expect ArgumentError.new("argument 'a', … may not follow optional 'b', …") do
    Ame::Arguments::Undefined.new.
      optional('a', nil, 'd').
      argument('b', String, 'd')
  end

  expect ArgumentError.new("splus 'b', … may not follow optional 'a', …") do
    Ame::Arguments::Undefined.new.
      optional('a', nil, 'd').
      splus('b', String, 'd')
  end

  expect ArgumentError.new("argument 'b', … may not follow splat 'a', …") do
    Ame::Arguments::Undefined.new.
      splat('a', String, 'd').
      argument('b', String, 'd')
  end

  expect ArgumentError.new("optional 'b', … may not follow splat 'a', …") do
    Ame::Arguments::Undefined.new.
      splat('a', String, 'd').
      optional('b', String, 'd')
  end

  expect ArgumentError.new("splat 'b', … may not follow splat 'a', …") do
    Ame::Arguments::Undefined.new.
      splat('a', String, 'd').
      splat('b', String, 'd')
  end

  expect ArgumentError.new("splus 'b', … may not follow splat 'a', …") do
    Ame::Arguments::Undefined.new.
      splat('a', String, 'd').
      splus('b', String, 'd')
  end

  expect ArgumentError.new("argument 'b', … may not follow splus 'a', …") do
    Ame::Arguments::Undefined.new.
      splus('a', String, 'd').
      argument('b', String, 'd')
  end

  expect ArgumentError.new("optional 'b', … may not follow splus 'a', …") do
    Ame::Arguments::Undefined.new.
      splus('a', String, 'd').
      optional('b', String, 'd')
  end

  expect ArgumentError.new("splat 'b', … may not follow splus 'a', …") do
    Ame::Arguments::Undefined.new.
      splus('a', String, 'd').
      splat('b', String, 'd')
  end

  expect ArgumentError.new("splus 'b', … may not follow splus 'a', …") do
    Ame::Arguments::Undefined.new.
      splus('a', String, 'd').
      splus('b', String, 'd')
  end
end
