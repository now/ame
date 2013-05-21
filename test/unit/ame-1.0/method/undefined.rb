# -*- coding: utf-8 -*-

Expectations do
  expect 'd' do Ame::Method::Undefined.new(nil).description('d').description end

  expect result.not.valid? do Ame::Method::Undefined.new(nil) end
  expect result.valid? do Ame::Method::Undefined.new(nil).description('d') end

  expect :name do Ame::Method::Undefined.new(nil).description('d').define(:name).name end

  expect mock.to.receive.method('b', 1, true, ['d', 'e', 'f'], {:a => true}).once do |o|
    Ame::Method::Undefined.new(o).
      flag('a', '', false, 'd').
      argument(:a, 'd').
      argument(:b, 'd', :type => Integer).
      argument(:c, 'd', :type => FalseClass).
      splat(:d, 'd').
      description('d').
      define(:method).
      process o, %w[b -a 1 on d e f]
  end

  expect mock.to.receive.method(1, false, [], {:a => true}).once do |o|
    Ame::Method::Undefined.new(o).
      flag('a', '', true, 'd').
      argument(:b, 'd', :optional => true, :default => 1).
      argument(:c, 'd', :optional => true, :default => false).
      splat(:d, 'd', :optional => true).
      description('d').
      define(:method).
      call o
  end
end
