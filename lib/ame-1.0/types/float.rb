# -*- coding: utf-8 -*-

module Ame::Types::Float
  Ame::Types.register self, Float

  def self.parse(argument)
    Float(argument)
  rescue ArgumentError
    raise Ame::MalformedArgument, 'not a float: %s' % argument
  end
end
