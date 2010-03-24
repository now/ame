# -*- coding: utf-8 -*-

class Ame::Splat < Ame::Argument
  def process(results, arguments)
    super nil, nil if required? and arguments.empty?
    result = []
    until arguments.empty?
      result << super(results, arguments)
    end
    result
  end

  def to_s
    super + '...'
  end
end
