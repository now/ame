# -*- coding: utf-8 -*-

# Defined method.
class Ame::Method
  class << self
    def ruby_name(name)
      name.to_s.gsub('-', '_').to_sym
    end

    def name(ruby_name)
      ruby_name.to_s.gsub('_', '-').to_sym
    end
  end

  def initialize(ruby_name, klass, description, options, arguments)
    @ruby_name, @class, @description, @options, @arguments =
      ruby_name, klass, description, options, arguments
  end

  def process(instance, arguments)
    options, remainder = @options.process(arguments)
    call(instance, @arguments.process(options, remainder), options)
  end

  def call(instance, arguments = nil, options = nil)
    options, _ = @options.process([]) unless options
    arguments ||= @arguments.process(options, [])
    instance.send @ruby_name, *(arguments + (options.empty? ? [] : [options]))
    self
  end

  attr_reader :description, :options, :arguments

  def name
    @name ||= self.class.name(@ruby_name)
  end

  def qualified_name
    [@class.fullname, name.to_s].reject{ |n| n.empty? }.join(' ')
  end
end
