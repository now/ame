# -*- coding: utf-8 -*-

Expectations do
  expect 'd' do Ame::Method.new(nil).description('d').description end

  expect result.not.valid? do Ame::Method.new(nil) end
  expect result.valid? do Ame::Method.new(nil).description('d') end

  expect :name do Ame::Method.new(nil).description('d').define(:name).name end

  expect mock.to.receive.method('b', 1, true, ['d', 'e', 'f'], {:a => true}).once do |o|
    Ame::Method.new(o).
      option(:a, 'd').
      argument(:a, 'd').
      argument(:b, 'd', :type => Integer).
      argument(:c, 'd', :type => FalseClass).
      splat(:d, 'd').
      description('d').
      define(:method).
      process o, %w[b -a 1 on d e f]
  end

  expect mock.to.receive.method(1, false, [], {:a => 5}).once do |o|
    Ame::Method.new(o).
      option(:a, 'd', :default => 5).
      argument(:b, 'd', :optional => true, :default => 1).
      argument(:c, 'd', :optional => true, :default => false).
      splat(:d, 'd', :optional => true).
      description('d').
      define(:method).
      call o
  end
end
