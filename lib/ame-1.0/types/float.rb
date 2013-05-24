# -*- coding: utf-8 -*-

module Ame::Types::Float
  Ame::Types.register self, Float

  def self.parse(value)
    Float(value)
  rescue ArgumentError
    raise Ame::MalformedArgument, 'not a float: %s' % value
  end
end
