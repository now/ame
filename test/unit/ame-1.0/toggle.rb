# -*- coding: utf-8 -*-

Expectations do
  expect TrueClass do
    Ame::Toggle.new('s', 'signoff', false, 'd').process({}, [], '--signoff', 'true')
  end

  expect FalseClass do
    Ame::Toggle.new('s', 'signoff', false, 'd').process({}, [], '--signoff', 'false')
  end

  expect TrueClass do
    Ame::Toggle.new('s', 'signoff', false, 'd').process({}, [], '--signoff', nil)
  end

  expect FalseClass do
    Ame::Toggle.new('s', 'signoff', false, 'd').process({}, [], '--no-signoff', nil)
  end

  expect Ame::MalformedArgument.new('--signoff: not a boolean: junk') do
    Ame::Toggle.new('s', 'signoff', false, 'd').process({}, [], '--signoff', 'junk')
  end

  expect Ame::MalformedArgument.new('--no-signoff: not a boolean: junk') do
    Ame::Toggle.new('s', 'signoff', false, 'd').process({}, [], '--no-signoff', 'junk')
  end
end
