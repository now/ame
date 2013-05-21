# -*- coding: utf-8 -*-

Expectations do
  expect ArgumentError.new('option already defined: a') do
    Ame::Options::Undefined.new.flag('a', '', false, 'd').flag('a', '', false, 'd')
  end

  expect result.include? 'a' do Ame::Options::Undefined.new.flag('a', '', false, 'd') end
  expect result.include? :a do Ame::Options::Undefined.new.flag('a', '', false, 'd') end

  expect({ :signoff => true }) do
    Ame::Options::Undefined.new.toggle('s', 'signoff', false, 'd').define.process(['--signoff=true']).first
  end

  expect({ :signoff => false }) do
    Ame::Options::Undefined.new.toggle('s', 'signoff', false, 'd').define.process(['--signoff=false']).first
  end

  expect({ :signoff => true }) do
    Ame::Options::Undefined.new.toggle('s', 'signoff', false, 'd').define.process(['--signoff=true']).first
    Ame::Options::Undefined.new.toggle('s', 'signoff', false, 'd').define.process(['--signoff']).first
  end

  expect({ :signoff => false }) do
    Ame::Options::Undefined.new.toggle('s', 'signoff', false, 'd').define.process(['--no-signoff']).first
  end

  expect Ame::MalformedArgument.new('--signoff: not a boolean: junk') do
    Ame::Options::Undefined.new.toggle('s', 'signoff', false, 'd').define.process(['--signoff=junk']).first
  end

  expect Ame::MalformedArgument.new('--no-signoff: not a boolean: junk') do
    Ame::Options::Undefined.new.toggle('s', 'signoff', false, 'd').define.process(['--no-signoff=junk']).first
  end
end
