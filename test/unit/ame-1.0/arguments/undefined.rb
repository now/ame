# -*- coding: utf-8 -*-

Expectations do
  expect ArgumentError.new("argument 'b', … must come before splus 'a', …") do
    Ame::Arguments::Undefined.new.
      splus(:a, String, 'd').
      argument(:b, 'd')
  end

  expect ArgumentError.new("argument 'a', … must come before optional 'b', …") do
    Ame::Arguments::Undefined.new.
      optional(:a, nil, 'd').
      argument(:b, 'd')
  end

  expect ArgumentError.new('splat argument a already defined: b') do
    Ame::Arguments::Undefined.new.
      splus(:a, String, 'd').
      splus(:b, String, 'd')
  end

  expect ArgumentError.new("splus 'b', … must come before optional 'a', …") do
    Ame::Arguments::Undefined.new.
      optional(:a, nil, 'd').
      splus(:b, String, 'd')
  end
end
