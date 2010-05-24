# -*- coding: utf-8 -*-

class Ame::Splat < Ame::Argument
  def arity
    -1
  end

  def process(options, processed, arguments)
    super options, processed, nil if required? and arguments.empty?
    [].tap{ |result|
      result << super(options, processed, arguments.shift) until arguments.empty?
    }
  end
end
