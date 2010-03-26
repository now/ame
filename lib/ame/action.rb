# -*- coding: utf-8 -*-

class Ame::Action
  extend Forwardable

  def defined?
    instance_variable_defined? :@description
  end

  def description(description = nil)
    return @description unless description
    @description = description
    self
  end

  def_delegators :options, :option

  def_delegators :arguments, :argument, :splat, :arity

  def process(arguments)
    options, remainder = self.options.process(arguments)
    [options, self.arguments.process(options, remainder)]
  end

  attr_accessor :name

protected

  def options
    @options ||= Ame::Options.new
  end

  def arguments
    @arguments ||= Ame::Arguments.new
  end
end
