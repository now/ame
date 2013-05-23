# -*- coding: utf-8 -*-

Expectations do
  expect :a do Ame::Argument.new(:a, 'd').name end

  expect 'd' do Ame::Argument.new(:a, 'd').description end

  expect result.not.optional? do Ame::Argument.new(:a, 'd') end
  expect result.optional? do Ame::Argument.new(:a, 'd', :optional => true) end

  expect result.required? do Ame::Argument.new(:a, 'd') end
  expect result.not.required? do Ame::Argument.new(:a, 'd', :optional => true) end

  expect 'A' do Ame::Argument.new(:a, 'd').to_s end

  expect ArgumentError do Ame::Argument.new(:a, 'd', :default => 1) end
  expect 1 do Ame::Argument.new(:a, 'd', :optional => true, :default => 1).default end

  expect ArgumentError do Ame::Argument.new(:a, 'd', :optional => true, :type => String, :default => 1) end
  expect 1 do Ame::Argument.new(:a, 'd', :optional => true, :type => Integer, :default => 1).default end
  expect ArgumentError do Ame::Argument.new(:a, 'd', :optional => true, :type => TrueClass, :default => false) end

  expect Ame::MissingArgument do Ame::Argument.new(:a, 'd').process({}, [], []) end
  expect nil do Ame::Argument.new(:a, 'd', :optional => true).process({}, [], []) end
  expect 'default' do Ame::Argument.new(:a, 'd', :optional => true, :default => 'default').process({}, [], []) end
  expect 'string' do Ame::Argument.new(:a, 'd').process({}, [], ['string']) end

  expect 1 do Ame::Argument.new(:a, 'd', :type => Integer).process({}, [], ['1']) end
  expect 2 do Ame::Argument.new(:a, 'd', :optional => true, :default => 1).process({}, [], ['2']) end
  expect Ame::MalformedArgument.new('A: not an integer: junk') do
    Ame::Argument.new(:a, 'd', :type => Integer).process({}, [], ['junk'])
  end

  expect TrueClass do Ame::Argument.new(:a, 'd', :type => TrueClass).process({}, [], ['true']) end
  expect TrueClass do Ame::Argument.new(:a, 'd', :optional => true, :default => true).process({}, [], []) end
  expect Ame::MalformedArgument.new('A: not a boolean: junk') do
    Ame::Argument.new(:a, 'd', :type => TrueClass).process({}, [], ['junk'])
  end

  expect FalseClass do Ame::Argument.new(:a, 'd', :type => FalseClass).process({}, [], ['false']) end
  expect FalseClass do Ame::Argument.new(:a, 'd', :optional => true, :default => false).process({}, [], []) end
  expect Ame::MalformedArgument.new('A: not a boolean: junk') do
    Ame::Argument.new(:a, 'd', :type => FalseClass).process({}, [], ['junk'])
  end

  expect :a => 1 do
    options = nil
    Ame::Argument.new(:a, 'd', :type => Integer){ |o, p, a| options = o }.process({:a => 1}, [1], ['2'])
    options
  end
  expect [1] do
    processed = nil
    Ame::Argument.new(:a, 'd', :type => Integer){ |o, p, a| processed = p }.process({:a => 1}, [1], ['2'])
    processed
  end
  expect 2 do
    argument = nil
    Ame::Argument.new(:a, 'd', :type => Integer){ |o, p, a| argument = a }.process({:a => 1}, [1], ['2'])
    argument
  end
  expect 3 do
    Ame::Argument.new(:a, 'd', :type => Integer){ |o, p, a| 3 }.process({:a => 1}, [1], ['2'])
  end
end
