# -*- coding: utf-8 -*-

class Ame::Splat < Ame::Argument
  def process(results, arguments)
    super results, nil if required? and arguments.empty?
    [].tap{ |result|
      result << super(results, arguments.shift) until arguments.empty?
    }
  end

  def to_s
    super + '...'
  end
end
