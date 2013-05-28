# -*- coding: utf-8 -*-

module Ame::Types::Integer
  Ame::Types.register self, Integer

  def self.parse(argument)
    Integer(argument)
  rescue ArgumentError
    raise Ame::MalformedArgument, 'not an integer: %s' % argument
  end
end
