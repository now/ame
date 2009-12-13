# -*- coding: utf-8 -*-

require 'ame/argument'

class Ame::Splat < Ame::Argument
  def process(results, arguments)
    super nil, nil if not optional? and arguments.empty?
    arguments.map{ |argument| super(results, argument) }
  end

  def to_s
    super + '...'
  end
end
