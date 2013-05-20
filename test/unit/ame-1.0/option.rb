# -*- coding: utf-8 -*-

Expectations do
  expect Ame::Argument do
    Ame::Option.new(:a, 'd')
  end

  expect ArgumentError do
    Ame::Option.new(:a, 'd', :type => String, :optional => true)
  end

  expect result.optional? do Ame::Option.new(:a, 'd') end
  expect result.not.optional? do Ame::Option.new(:a, 'd', :type => String) end

  expect FalseClass do
    Ame::Option.new(:a, 'd').default
  end

  expect TrueClass do
    Ame::Option.new(:a, 'd').process({}, [], 'a', 'true')
  end

  expect FalseClass do
    Ame::Option.new(:a, 'd').process({}, [], 'a', 'off')
  end

  expect 'string' do
    Ame::Option.new(:a, 'd', :type => String).process({}, [], 'a', 'string')
  end

  expect 'a' do
    Ame::Option.new(:a, 'd', :type => String).argument_name
  end

  expect 'b' do
    Ame::Option.new(:a, 'd', :argument => 'b', :type => String).argument_name
  end

  expect ArgumentError do
    Ame::Option.new(:a, 'd', :argument => 'a').argument_name
  end

  expect [:b] do
    Ame::Option.new(:a, 'd', :aliases => :b).aliases
  end

  expect [:b, :c, :d] do
    Ame::Option.new(:a, 'd', :aliases => [:b, :c, :d]).aliases
  end

  expect [:b, :c, :d] do
    Ame::Option.new(:a, 'd', :alias => :b, :aliases => [:c, :d]).aliases
  end

  expect '-a' do
    Ame::Option.new(:a, 'd').to_s
  end

  expect '--abc' do
    Ame::Option.new(:abc, 'd').to_s
  end

  expect :a do
    Ame::Option.new(:abc, 'd', :aliases => [:a, :b]).short
  end

  expect :abc do
    Ame::Option.new(:a, 'd', :aliases => [:abc, :b]).long
  end

  expect result.not.ignored? do Ame::Option.new(:a, 'd') end

  expect result.ignored? do Ame::Option.new(:a, 'd', :ignore => true) end
end
