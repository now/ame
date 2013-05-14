# -*- coding: utf-8 -*-

class Ame::Arguments
  class << self
    def arity(arguments, splat)
      required = arguments.select{ |a| a.required? }.size
      all_required = required + (splat && splat.required? ? 1 : 0)
      splat || required < arguments.size ? -all_required - 1 : all_required
    end
  end

  include Enumerable

  def initialize(arguments, splat)
    @arguments, @splat = arguments, splat
  end

  def arity
    self.class.arity(@arguments, @splat)
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

  attr_reader :splat
end
