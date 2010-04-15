# -*- coding: utf-8 -*-

class Ame::Method
  extend Forwardable

  def initialize(klass)
    @class = klass
    @called = false
  end

  def defined?
    instance_variable_defined? :@description
  end

  def description(description = nil)
    return @description unless description
    @description = description
    self
  end

  def_delegators :options, :option, :options_must_precede_arguments

  def_delegators :arguments, :argument, :splat, :arity

  def process(arguments)
    return self if @called
    options, remainder = self.options.process(arguments)
    call(self.arguments.process(options, remainder), options)
  end

  def call(arguments = nil, options = nil)
    return self if @called
    options, remainder = self.options.process([]) unless options
    arguments ||= self.arguments.process(options, [])
    arguments << options
    @class.instance.send name, *arguments
    @called = true
    self
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
