# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Class.new.extend(Ame::Base::ClassMethods).to.delegate(:description).to(:method) do |o|
    o.description 'd'
  end

  expect Class.new.extend(Ame::Base::ClassMethods).to.delegate(:options_must_precede_arguments).to(:method) do |o|
    o.options_must_precede_arguments
  end

  expect Class.new.extend(Ame::Base::ClassMethods).to.delegate(:option).to(:method) do |o|
    o.option 'a', 'd'
  end

  expect Class.new.extend(Ame::Base::ClassMethods).to.delegate(:argument).to(:method) do |o|
    o.argument 'a', 'd'
  end

  expect Class.new.extend(Ame::Base::ClassMethods).to.delegate(:splat).to(:method) do |o|
    o.splat 'a', 'd'
  end

  expect [:a, :b] do
    c = Class.new.extend(Ame::Base::ClassMethods)
    c.class_eval do
      description 'd'
      def a() end

      description 'e'
      def b() end
    end
    c.methods.entries.map{ |m| m.name }
  end
end
