# -*- coding: utf-8 -*-

class Ame::Arguments
  include Enumerable

  def initialize
    @arguments = []
    @splat = nil
  end

  def argument(name, description, options = {}, &block)
    argument = Ame::Argument.new(name, description, options, &block)
    raise ArgumentError,
      'argument %s may not follow splat argument %s' %
        [argument.name, splat.name] if @splat
    raise ArgumentError,
      'Required argument %s must come before optional argument %s' %
        [argument.name, first_optional.name] if argument.required? and first_optional
    @arguments << argument
    self
  end

  def splat(name = nil, description = nil, options = {}, &validate)
    return @splat unless name
    splat = Ame::Splat.new(name, description, options, &validate)
    raise ArgumentError,
      'Splat argument %s already defined: %s' % [@splat.name, splat.name] if @splat
    raise ArgumentError,
      'Optional argument %s may not precede required splat argument %s' %
        [first_optional.name, splat.name] if splat.required? and first_optional
    @splat = splat
    self
  end

  def arity
    required = @arguments.select{ |a| a.required? }.size +
               (@splat && @splat.required? ? 1 : 0)
    @splat || first_optional ? -required - 1 : required
  end

  def process(options, arguments)
    [].tap{ |processed|
      @arguments.each do |argument|
        processed << argument.process(options, processed, arguments.shift)
      end
      processed << @splat.process(options, processed, arguments) if @splat
    }
  end

  def each
    @arguments.each do |argument|
      yield argument
    end
    self
  end

private

  def first_optional
    @arguments.find{ |a| a.optional? }
  end
end
