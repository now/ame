# -*- coding: utf-8 -*-

Expectations do
  expect Enumerable do
    Ame::Options::Undefined.new.define
  end

  expect [:a, :b] do
    Ame::Options::Undefined.new.flag('a', '', false, 'd').flag('b', '', false, 'd').define.map{ |o| o.name }
  end

  expect [{:a => 1, :b => 2}, []] do
    Ame::Options::Undefined.new.
      option('a', '', 'A', 1, 'd').
      option('b', '', 'B', 2, 'd').
      define.
      process([])
  end

  expect [{:a => 3, :b => 4}, []] do
    Ame::Options::Undefined.new.
      option('a', '', 'A', 1, 'd').
      option('b', '', 'B', 2, 'd').
      define.
      process(['-a=3', '-b=4'])
  end

  expect [{:a => 3, :b => 4}, []] do
    Ame::Options::Undefined.new.
      option('a', '', 'A', 1, 'd').
      option('b', '', 'B', 2, 'd').
      define.
      process(['-a', '3', '-b', '4'])
  end

  expect Ame::MalformedArgument do
    Ame::Options::Undefined.new.option('a', '', 'A', 1, 'd').define.process(['-a='])
  end

  expect Ame::MissingArgument do
    Ame::Options::Undefined.new.option('a', '', 'A', 1, 'd').define.process(['-a'])
  end

  expect Ame::UnrecognizedOption do
    Ame::Options::Undefined.new.option('a', '', 'A', 1, 'd').define.process(['-b'])
  end

  expect Ame::MalformedArgument do
    Ame::Options::Undefined.new.
      option('a', '', 'A', 1, 'd').
      option('b', '', 'B', 2, 'd').
      define.
      process(['-ab'])
  end

  expect Ame::MissingArgument do
    Ame::Options::Undefined.new.
      flag('a', '', false, 'd').
      option('b', '', 'B', 2, 'd').
      define.
      process(['-ab'])
  end

  expect [{:a => true, :b => 3}, []] do
    Ame::Options::Undefined.new.
      flag('a', '', false, 'd').
      option('b', '', 'B', 2, 'd').
      define.
      process(['-ab3'])
  end

  expect [{:a => true, :b => 3}, []] do
    Ame::Options::Undefined.new.
      flag('a', '', false, 'd').
      option('b', '', 'B', 2, 'd').
      define.
      process(['-ab', '3'])
  end

  expect [{:a => true, :b => true}, []] do
    Ame::Options::Undefined.new.
      flag('a', '', false, 'd').
      flag('b', '', false, 'd').
      define.
      process(['-ab'])
  end

  expect [{:a => true, :b => true}, []] do
    Ame::Options::Undefined.new.
      flag('a', '', false, 'd').
      flag('b', '', false, 'd').
      define.
      process(['-a', '-b'])
  end

  expect [{:a => true, :b => false}, ['-b']] do
    Ame::Options::Undefined.new.
      flag('a', '', false, 'd').
      flag('b', '', false, 'd').
      define.
      process(['-a', '--', '-b'])
  end

  expect [{:a => true, :b => true}, ['arg']] do
    stub(ENV).include?{ false }
    Ame::Options::Undefined.new.
      flag('a', '', false, 'd').
      flag('b', '', false, 'd').
      define.
      process(['arg', '-a', '-b'])
  end

  expect [{:a => false, :b => false}, ['arg', '-a', '-b']] do
    Ame::Options::Undefined.new.
      options_must_precede_arguments.
      flag('a', '', false, 'd').
      flag('b', '', false, 'd').
      define.
      process(['arg', '-a', '-b'])
  end

=begin
  expect [{:a => true}, []] do
    Ame::Options::Undefined.new.flag('b', 'a', false, 'd').define.process(['-b'])
  end
=end

  expect [{:a => false}, []] do
    Ame::Options::Undefined.new.flag('a', '', true, 'd').define.process(['-a'])
  end

  expect [{:abc => true}, []] do
    Ame::Options::Undefined.new.flag('', 'abc', false, 'd').define.process(['--abc'])
  end

  expect [{:abc => 1}, []] do
    Ame::Options::Undefined.new.option('', 'abc', 'N', 0, 'd').define.process(['--abc=1'])
  end

  expect [{:abc => 1}, []] do
    Ame::Options::Undefined.new.option('', 'abc', 'N', 0, 'd').define.process(['--abc', '1'])
  end

  expect [{}, []] do
    Ame::Options::Undefined.new.flag('', 'abc', nil, 'd').define.process(['--abc'])
  end

  expect [{:a => [1, 2, 3]}, []] do
    Ame::Options::Undefined.new.option('a', '', 'N', Ame::Types::Array[Integer], 'd').define.process(%w[-a 1 -a 2 -a 3])
  end
end
