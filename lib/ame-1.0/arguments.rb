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
    required = @arguments.select{ |a| a.required? }.size +
               (@splat && @splat.required? ? 1 : 0)
    @splat || first_optional ? -required - 1 : required
  end

  def process(options, arguments)
    unprocessed = arguments.dup
    reduce([]){ |processed, argument|
      processed << argument.process(options, processed,
                                    argument.arity < 0 ? unprocessed : unprocessed.shift)
    }.tap{
      raise Ame::SuperfluousArgument,
        'superfluous arguments: %s' % unprocessed.join(' ') unless unprocessed.empty?
    }
  end

  def each
    @arguments.each do |argument|
      yield argument
    end
    yield @splat if @splat
    self
  end

private

  def first_optional
    @arguments.find{ |a| a.optional? }
  end
end
