# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect ArgumentError do
    Ame::Options.new.option('a', 'd').option('a', 'd')
  end

  expect [{'a' => 1, 'b' => 2}, []] do
    Ame::Options.new.
      option('a', 'd', :default => 1).
      option('b', 'd', :default => 2).process([])
  end

  expect [{'a' => 3, 'b' => 4}, []] do
    Ame::Options.new.
      option('a', 'd', :default => 1).
      option('b', 'd', :default => 2).process(['-a=3', '-b=4'])
  end

  expect [{'a' => 3, 'b' => 4}, []] do
    Ame::Options.new.
      option('a', 'd', :default => 1).
      option('b', 'd', :default => 2).process(['-a', '3', '-b', '4'])
  end

  expect Ame::MalformedArgument do
    Ame::Options.new.option('a', 'd', :default => 1).process(['-a='])
  end

  expect Ame::MissingArgument do
    Ame::Options.new.option('a', 'd', :default => 1).process(['-a'])
  end

  expect Ame::UnrecognizedOption do
    Ame::Options.new.option('a', 'd', :default => 1).process(['-b'])
  end

  expect [{'a' => true, 'b' => true}, []] do
    Ame::Options.new.
      option('a', 'd').
      option('b', 'd').process(['-ab'])
  end

  expect [{'a' => true, 'b' => true}, []] do
    Ame::Options.new.
      option('a', 'd').
      option('b', 'd').process(['-a', '-b'])
  end

  expect [{'a' => true, 'b' => false}, ['-b']] do
    Ame::Options.new.
      option('a', 'd').
      option('b', 'd').process(['-a', '--', '-b'])
  end

  expect [{'a' => true, 'b' => true}, ['arg']] do
    ENV.stubs(:include?).returns(false)
    Ame::Options.new.
      option('a', 'd').
      option('b', 'd').process(['arg', '-a', '-b'])
  end

  expect [{'a' => false, 'b' => false}, ['arg', '-a', '-b']] do
    ENV.stubs(:include?).returns(true)
    Ame::Options.new.
      option('a', 'd').
      option('b', 'd').process(['arg', '-a', '-b'])
  end

  expect [{'a' => true}, []] do
    Ame::Options.new.option('a', 'd', :aliases => ['b']).process(['-b'])
  end

  expect [{'a' => false}, []] do
    Ame::Options.new.option('a', 'd', :default => true).process(['-a'])
  end

  expect [{'abc' => true}, []] do
    Ame::Options.new.option('abc', 'd').process(['--abc'])
  end

  expect [{'abc' => 1}, []] do
    Ame::Options.new.option('abc', 'd', :type => Integer).process(['--abc=1'])
  end

  expect [{'abc' => 1}, []] do
    Ame::Options.new.option('abc', 'd', :type => Integer).process(['--abc', '1'])
  end
end
