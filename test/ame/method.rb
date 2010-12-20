# -*- coding: utf-8 -*-

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

  expect Ame::Method.new(nil).not.to.be.valid?

  expect Ame::Method.new(nil).description('d').to.be.valid?

  expect :name do
    Ame::Method.new(nil).description('d').define(:name).name
  end

  expect mock.to.receive.method('b', 1, true, ['d', 'e', 'f'], {'help' => false, 'a' => true}).once do |o|
    method = Ame::Method.new(o)
    method.option('a', 'd')
    method.argument('a', 'd')
    method.argument('b', 'd', :type => Integer)
    method.argument('c', 'd', :type => FalseClass)
    method.splat('d', 'd')
    method.description 'd'
    method.define(:method)
    method.process o, ['b', '-a', '1', 'on', 'd', 'e', 'f']
  end

  expect mock.to.receive.method(1, false, [], {'help' => false, 'a' => 5}).once do |o|
    method = Ame::Method.new(o)
    method.option('a', 'd', :default => 5)
    method.argument('b', 'd', :optional => true, :default => 1)
    method.argument('c', 'd', :optional => true, :default => false)
    method.splat('d', 'd', :optional => true)
    method.description 'd'
    method.define(:method)
    method.call o
  end

  expect Ame::Class.to.receive.help_for_method(Ame::Method) do |o|
    catch Ame::AbortAllProcessing do
      Ame::Method.new(o).description('d').define(:method).process o, ['--help']
    end
  end
end
