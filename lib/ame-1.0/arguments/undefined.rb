# -*- coding: utf-8 -*-

class Ame::Arguments::Undefined
  def initialize
    @arguments, @splat = [], nil
  end

  def argument(name, description, options = {}, &block)
    argument = Ame::Argument.new(name, description, options, &block)
    raise ArgumentError,
      'argument %s must come before splat argument %s' %
        [argument.name, splat.name] if @splat
    raise ArgumentError,
      'optional argument %s may not precede required argument %s' %
        [first_optional.name, argument.name] if argument.required? and first_optional
    @arguments << argument
    self
  end

  def splat(name = nil, description = nil, options = {}, &validate)
    return @splat unless name
    splat = Ame::Splat.new(name, description, options, &validate)
    raise ArgumentError,
      'splat argument %s already defined: %s' % [@splat.name, splat.name] if @splat
    raise ArgumentError,
      'optional argument %s may not precede required splat argument %s' %
        [first_optional.name, splat.name] if splat.required? and first_optional
    @splat = splat
    self
  end

  def arity
    Ame::Arguments.arity(@arguments, @splat)
  end

  def define
    Ame::Arguments.new(@arguments, @splat)
  end

  private

  def first_optional
    @arguments.find{ |a| a.optional? }
  end
end
