# -*- coding: utf-8 -*-

require 'forwardable'

class Ame; end

class Ame::Action
  extend Forwardable

  def initialize
    @options = Ame::Options.new
    @arguments = Ame::Arguments.new
  end

  def defined?
    # TODO: If one of @options and @arguments is non-empty, we should really
    # raise an alarm about the description missing for what the user probably
    # wanted to be an action.
    instance_variable_defined? :@description
  end

  def description(description)
    @description = description
  end

  def_delegators :@options, :option

  def_delegators :@arguments, :argument, :splat

  def has_arguments?
    @arguments.count > 0
  end

  def process(arguments)
    options, remainder = @options.process(arguments)
    [options, @arguments.process(remainder)]
  end
end
