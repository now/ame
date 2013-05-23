# -*- coding: utf-8 -*-

class Ame::Arguments
  include Enumerable

  def initialize(arguments, splat)
    @arguments, @splat = arguments, splat
  end

  def process(options, arguments)
    unprocessed = arguments.dup
    reduce([]){ |processed, argument|
      processed << argument.process(options, processed, unprocessed)
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
end
