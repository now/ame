# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect 'a' do
    Ame::Argument.new('a', 'd').name
  end

  expect 'd' do
    Ame::Argument.new('a', 'd').description
  end

  expect Ame::Argument.new('a', 'd').not.to.be.optional? 
  expect Ame::Argument.new('a', 'd').to.be.required? 
  expect Ame::Argument.new('a', 'd', :optional => true).to.be.optional? 
  expect Ame::Argument.new('a', 'd', :optional => true).not.to.be.required? 

  expect ArgumentError do
    Ame::Argument.new('a', 'd', :default => 1).default
  end

  expect ArgumentError do
    Ame::Argument.new('a', 'd', :optional => true, :type => String, :default => 1)
  end

  expect 1 do
    Ame::Argument.new('a', 'd', :optional => true, :default => 1).default
  end

  expect nil do
    Ame::Argument.new('a', 'd', :optional => true).process([], nil)
  end

  expect 'default' do
    Ame::Argument.new('a', 'd', :optional => true, :default => 'default').process([], nil)
  end

  expect 'string' do
    Ame::Argument.new('a', 'd').process([], 'string')
  end

  expect 1 do
    Ame::Argument.new('a', 'd', :type => Integer).process([], '1')
  end

  expect 2 do
    Ame::Argument.new('a', 'd', :optional => true, :default => 1).process([], '2')
  end

  expect Ame::MalformedArgument do
    Ame::Argument.new('a', 'd', :type => Integer).process([], '')
  end

  expect 'string' do
    Ame::Argument.new('a', 'd').process([], 'string')
  end

  expect Ame::MalformedArgument do
    Ame::Argument.new('a', 'd', :type => Integer).process([], 'junk')
  end

  expect 'A is not an integer: junk' do
    begin
      Ame::Argument.new('a', 'd', :type => Integer).process([], 'junk')
    rescue => e
      e.message
    end
  end

  expect ArgumentError do
    Ame::Argument.new('a', 'd', :optional => true, :type => TrueClass, :default => false)
  end

  ['true', 'yes', 'on'].each do |s|
    expect TrueClass do
      Ame::Argument.new('a', 'd', :type => TrueClass).process([], s)
    end
  end

  ['false', 'no', 'off'].each do |s|
    expect FalseClass do
      Ame::Argument.new('a', 'd', :type => FalseClass).process([], s)
    end
  end

  expect TrueClass do
    Ame::Argument.new('a', 'd', :optional => true, :default => false).process([], nil)
  end

  expect FalseClass do
    Ame::Argument.new('a', 'd', :optional => true, :default => true).process([], nil)
  end

  expect Ame::MalformedArgument do
    Ame::Argument.new('a', 'd', :type => TrueClass).process([], 'junk')
  end

  expect 'A' do
    Ame::Argument.new('a', 'd').to_s
  end

  expect '[A]' do
    Ame::Argument.new('a', 'd', :optional => true).to_s
  end

  expect [1] do
    results = nil
    Ame::Argument.new('a', 'd', :type => Integer){ |r, a| results = r }.process([1], '2')
    results
  end

  expect 2 do
    argument = nil
    Ame::Argument.new('a', 'd', :type => Integer){ |r, a| argument = a }.process([1], '2')
    argument
  end

  expect 3 do
    Ame::Argument.new('a', 'd', :type => Integer){ |r, a| 3 }.process([1], '2')
  end

  expect Ame::MissingArgument do
    Ame::Argument.new('a', 'd').process([], nil)
  end

  expect nil do
    Ame::Argument.new('a', 'd', :optional => true).process([], nil)
  end

  expect 'string' do
    Ame::Argument.new('a', 'd', :optional => true, :default => 'string').process([], nil)
  end
end
