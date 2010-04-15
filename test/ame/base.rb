# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Ame::Classes.to.receive(:method).with(:name, anything).returns(ignore) do |o|
    Class.new.instance_eval{ include Ame::Base }.new.process(:name)
  end

  expect Ame::Classes.to.receive(:method).with(:name, anything).returns(ignore) do |o|
    Class.new.instance_eval{ include Ame::Base }.new.call(:name)
  end

  expect mock.to.receive(:process).with(['1', '2', '3', '-a=3']) do |o|
    Ame::Classes.stubs(:method).returns(o)
    Class.new.instance_eval{ include Ame::Base }.new.process(:name, ['1', '2', '3', '-a=3'])
  end

  expect mock.to.receive(:call).with([1, 2, 3], {:a => 3}) do |o|
    Ame::Classes.stubs(:method).returns(o)
    Class.new.instance_eval{ include Ame::Base }.new.call(:name, [1, 2, 3], {:a => 3})
  end

  expect Class.new.instance_eval{ include Ame::Base }.new do |o|
    Ame::Classes.stubs(:method).returns(ignore)
    o.expected.process(:method)
  end

  expect Class.new.instance_eval{ include Ame::Base }.new do |o|
    Ame::Classes.stubs(:method).returns(ignore)
    o.expected.new.call(:method)
  end
end
