# -*- coding: utf-8 -*-

class Ame::Splat < Ame::Argument
  def arity
    -1
  end

  def process(options, processed, arguments)
    super options, processed, nil if required? and arguments.empty?
    arguments.map{ |argument| super(options, processed, argument) }.tap{ arguments.clear }
  end
end
