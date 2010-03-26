# -*- coding: utf-8 -*-

module Ame::Types::Integer
  Ame::Types.register self, Integer

  def self.parse(argument, value)
    return argument.default if value.nil?
    Integer(value)
  rescue ArgumentError
    raise Ame::MalformedArgument, "#{argument} is not an integer: #{value}"
  end
end