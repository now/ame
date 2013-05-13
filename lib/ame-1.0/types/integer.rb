# -*- coding: utf-8 -*-

module Ame::Types::Integer
  Ame::Types.register self, Integer

  def self.parse(value)
    Integer(value)
  rescue ArgumentError
    raise Ame::MalformedArgument, 'not an integer: %s' % value
  end
end
