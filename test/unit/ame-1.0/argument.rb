# -*- coding: utf-8 -*-

Expectations do
  expect :a do Ame::Argument.new(:a, 'd').name end

  expect 'd' do Ame::Argument.new(:a, 'd').description end

  expect 'A' do Ame::Argument.new(:a, 'd').to_s end

  expect Ame::MissingArgument do Ame::Argument.new(:a, 'd').process({}, [], []) end
  expect 'string' do Ame::Argument.new(:a, 'd').process({}, [], ['string']) end

  expect 1 do Ame::Argument.new(:a, 'd', :type => Integer).process({}, [], ['1']) end
  expect Ame::MalformedArgument.new('A: not an integer: junk') do
    Ame::Argument.new(:a, 'd', :type => Integer).process({}, [], ['junk'])
  end

  expect TrueClass do Ame::Argument.new(:a, 'd', :type => TrueClass).process({}, [], ['true']) end
  expect Ame::MalformedArgument.new('A: not a boolean: junk') do
    Ame::Argument.new(:a, 'd', :type => TrueClass).process({}, [], ['junk'])
  end

  expect FalseClass do Ame::Argument.new(:a, 'd', :type => FalseClass).process({}, [], ['false']) end
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
