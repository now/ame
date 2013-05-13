# -*- coding: utf-8 -*-

Expectations do
  expect Enumerable do
    Ame::Options.new
  end

  expect [:a, :b] do
    Ame::Options.new.option('a', 'd').option('b', 'd').map{ |o| o.name }
  end

  expect [:a, :b] do
    Ame::Options.new.option(:a, 'd').option(:b, 'd').map{ |o| o.name }
  end

  expect ArgumentError do
    Ame::Options.new.option(:a, 'd').option(:a, 'd')
  end

  expect result.include? 'a' do Ame::Options.new.option(:a, 'd') end
  expect result.include? :a do Ame::Options.new.option(:a, 'd') end

  expect [{:a => 1, :b => 2}, []] do
    Ame::Options.new.
      option(:a, 'd', :default => 1).
      option(:b, 'd', :default => 2).process([])
  end

  expect [{:a => 3, :b => 4}, []] do
    Ame::Options.new.
      option(:a, 'd', :default => 1).
      option(:b, 'd', :default => 2).process(['-a=3', '-b=4'])
  end

  expect [{:a => 3, :b => 4}, []] do
    Ame::Options.new.
      option(:a, 'd', :default => 1).
      option(:b, 'd', :default => 2).process(['-a', '3', '-b', '4'])
  end

  expect Ame::MalformedArgument do
    Ame::Options.new.option(:a, 'd', :default => 1).process(['-a='])
  end

  expect Ame::MissingArgument do
    Ame::Options.new.option(:a, 'd', :default => 1).process(['-a'])
  end

  expect Ame::UnrecognizedOption do
    Ame::Options.new.option(:a, 'd', :default => 1).process(['-b'])
  end

  expect Ame::MalformedArgument do
    Ame::Options.new.
      option(:a, 'd', :default => 1).
      option(:b, 'd').process(['-ab'])
  end

  expect Ame::MissingArgument do
    Ame::Options.new.
      option(:a, 'd').
      option(:b, 'd', :default => 1).process(['-ab'])
  end

  expect [{:a => true, :b => 2}, []] do
    Ame::Options.new.
      option(:a, 'd').
      option(:b, 'd', :default => 1).process(['-ab2'])
  end

  expect [{:a => true, :b => 2}, []] do
    Ame::Options.new.
      option(:a, 'd').
      option(:b, 'd', :default => 1).process(['-ab', '2'])
  end

  expect [{:a => true, :b => true}, []] do
    Ame::Options.new.
      option(:a, 'd').
      option(:b, 'd').process(['-ab'])
  end

  expect [{:a => true, :b => true}, []] do
    Ame::Options.new.
      option(:a, 'd').
      option(:b, 'd').process(['-a', '-b'])
  end

  expect [{:a => true, :b => false}, ['-b']] do
    Ame::Options.new.
      option(:a, 'd').
      option(:b, 'd').process(['-a', '--', '-b'])
  end

  expect [{:a => true, :b => true}, ['arg']] do
    stub(ENV).include?{ false }
    Ame::Options.new.
      option(:a, 'd').
      option(:b, 'd').process(['arg', '-a', '-b'])
  end

  expect [{:a => false, :b => false}, ['arg', '-a', '-b']] do
    Ame::Options.new.
      options_must_precede_arguments.
      option(:a, 'd').
      option(:b, 'd').process(['arg', '-a', '-b'])
  end

  expect [{:a => true}, []] do
    Ame::Options.new.option(:a, 'd', :aliases => [:b]).process(['-b'])
  end

  expect [{:a => false}, []] do
    Ame::Options.new.option(:a, 'd', :default => true).process(['-a'])
  end

  expect [{:abc => true}, []] do
    Ame::Options.new.option(:abc, 'd').process(['--abc'])
  end

  expect [{:abc => 1}, []] do
    Ame::Options.new.option(:abc, 'd', :type => Integer).process(['--abc=1'])
  end

  expect [{:abc => 1}, []] do
    Ame::Options.new.option(:abc, 'd', :type => Integer).process(['--abc', '1'])
  end

  expect [{}, []] do
    Ame::Options.new.option(:abc, 'd', :ignore => true).process(['--abc'])
  end

  expect [{:a => [1, 2, 3]}, []] do
    Ame::Options.new.option(:a, 'd', :type => Ame::Types::Array[Integer]).process(%w[-a 1 -a 2 -a 3])
  end
end
