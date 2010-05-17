# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Ame::Method.new(nil).to.delegate(:option).to(:options) do |method|
    method.option 'a', 'd'
  end

  expect Ame::Method.new(nil).to.delegate(:options_must_precede_arguments).to(:options) do |method|
    method.options_must_precede_arguments
  end

  expect Ame::Method.new(nil).to.delegate(:argument).to(:arguments) do |method|
    method.argument 'a', 'd'
  end

  expect Ame::Method.new(nil).to.delegate(:splat).to(:arguments) do |method|
    method.splat 'a', 'd'
  end

  expect Ame::Method.new(nil).to.delegate(:arity).to(:arguments) do |method|
    method.arity
  end

  expect 'd' do
    Ame::Method.new(nil).description('d').description
  end

  expect ArgumentError do
    Ame::Method.new(nil).validate
  end

  expect true do
    Ame::Method.new(nil).description('d').validate
  end

  expect 'name' do
    method = Ame::Method.new(nil)
    method.name = 'name'
    method.name
  end

  expect mock.to.receive(:method).with('b', 1, true, ['d', 'e', 'f'], {'help' => false, 'a' => true}).once do |o|
    o.stubs(:instance).returns(o)
    method = Ame::Method.new(o)
    method.option('a', 'd')
    method.argument('a', 'd')
    method.argument('b', 'd', :type => Integer)
    method.argument('c', 'd', :type => FalseClass)
    method.splat('d', 'd')
    method.name = :method
    method.process(['b', '-a', '1', 'on', 'd', 'e', 'f'])
    method.process(['b', '-a', '1', 'on', 'd', 'e', 'f'])
  end

  expect mock.to.receive(:method).with(1, false, [], {'help' => false, 'a' => 5}).once do |o|
    o.stubs(:instance).returns(o)
    method = Ame::Method.new(o)
    method.option('a', 'd', :default => 5)
    method.argument('b', 'd', :optional => true, :default => 1)
    method.argument('c', 'd', :optional => true, :default => false)
    method.splat('d', 'd', :optional => true)
    method.name = :method
    method.call
  end

  expect Ame::Class.to.receive(:help_for_method).with(instance_of(Ame::Method)) do |o|
    method = Ame::Method.new(o)
    method.process ['--help']
  end
end
