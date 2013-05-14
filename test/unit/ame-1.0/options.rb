# -*- coding: utf-8 -*-

Expectations do
  expect Enumerable do
    Ame::Options::Undefined.new.define
  end

  expect [:a, :b] do
    Ame::Options::Undefined.new.option('a', 'd').option('b', 'd').define.map{ |o| o.name }
  end

  expect [:a, :b] do
    Ame::Options::Undefined.new.option(:a, 'd').option(:b, 'd').define.map{ |o| o.name }
  end

  expect [{:a => 1, :b => 2}, []] do
    Ame::Options::Undefined.new.
      option(:a, 'd', :default => 1).
      option(:b, 'd', :default => 2).
      define.
      process([])
  end

  expect [{:a => 3, :b => 4}, []] do
    Ame::Options::Undefined.new.
      option(:a, 'd', :default => 1).
      option(:b, 'd', :default => 2).
      define.
      process(['-a=3', '-b=4'])
  end

  expect [{:a => 3, :b => 4}, []] do
    Ame::Options::Undefined.new.
      option(:a, 'd', :default => 1).
      option(:b, 'd', :default => 2).
      define.
      process(['-a', '3', '-b', '4'])
  end

  expect Ame::MalformedArgument do
    Ame::Options::Undefined.new.option(:a, 'd', :default => 1).define.process(['-a='])
  end

  expect Ame::MissingArgument do
    Ame::Options::Undefined.new.option(:a, 'd', :default => 1).define.process(['-a'])
  end

  expect Ame::UnrecognizedOption do
    Ame::Options::Undefined.new.option(:a, 'd', :default => 1).define.process(['-b'])
  end

  expect Ame::MalformedArgument do
    Ame::Options::Undefined.new.
      option(:a, 'd', :default => 1).
      option(:b, 'd').
      define.
      process(['-ab'])
  end

  expect Ame::MissingArgument do
    Ame::Options::Undefined.new.
      option(:a, 'd').
      option(:b, 'd', :default => 1).
      define.
      process(['-ab'])
  end

  expect [{:a => true, :b => 2}, []] do
    Ame::Options::Undefined.new.
      option(:a, 'd').
      option(:b, 'd', :default => 1).
      define.
      process(['-ab2'])
  end

  expect [{:a => true, :b => 2}, []] do
    Ame::Options::Undefined.new.
      option(:a, 'd').
      option(:b, 'd', :default => 1).
      define.
      process(['-ab', '2'])
  end

  expect [{:a => true, :b => true}, []] do
    Ame::Options::Undefined.new.
      option(:a, 'd').
      option(:b, 'd').
      define.
      process(['-ab'])
  end

  expect [{:a => true, :b => true}, []] do
    Ame::Options::Undefined.new.
      option(:a, 'd').
      option(:b, 'd').
      define.
      process(['-a', '-b'])
  end

  expect [{:a => true, :b => false}, ['-b']] do
    Ame::Options::Undefined.new.
      option(:a, 'd').
      option(:b, 'd').
      define.
      process(['-a', '--', '-b'])
  end

  expect [{:a => true, :b => true}, ['arg']] do
    stub(ENV).include?{ false }
    Ame::Options::Undefined.new.
      option(:a, 'd').
      option(:b, 'd').
      define.
      process(['arg', '-a', '-b'])
  end

  expect [{:a => false, :b => false}, ['arg', '-a', '-b']] do
    Ame::Options::Undefined.new.
      options_must_precede_arguments.
      option(:a, 'd').
      option(:b, 'd').
      define.
      process(['arg', '-a', '-b'])
  end

  expect [{:a => true}, []] do
    Ame::Options::Undefined.new.option(:a, 'd', :aliases => [:b]).define.process(['-b'])
  end

  expect [{:a => false}, []] do
    Ame::Options::Undefined.new.option(:a, 'd', :default => true).define.process(['-a'])
  end

  expect [{:abc => true}, []] do
    Ame::Options::Undefined.new.option(:abc, 'd').define.process(['--abc'])
  end

  expect [{:abc => 1}, []] do
    Ame::Options::Undefined.new.option(:abc, 'd', :type => Integer).define.process(['--abc=1'])
  end

  expect [{:abc => 1}, []] do
    Ame::Options::Undefined.new.option(:abc, 'd', :type => Integer).define.process(['--abc', '1'])
  end

  expect [{}, []] do
    Ame::Options::Undefined.new.option(:abc, 'd', :ignore => true).define.process(['--abc'])
  end

  expect [{:a => [1, 2, 3]}, []] do
    Ame::Options::Undefined.new.option(:a, 'd', :type => Ame::Types::Array[Integer]).define.process(%w[-a 1 -a 2 -a 3])
  end
end
