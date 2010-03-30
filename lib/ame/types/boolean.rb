# -*- coding: utf-8 -*-

module Ame::Types::Boolean
  Ame::Types.register self, TrueClass, FalseClass

  def self.parse(argument, value)
    case value
    when 'true', 'yes', 'on'
      true
    when 'false', 'no', 'off'
      false
    else
      raise Ame::MalformedArgument, "#{argument} is not a boolean: #{value}"
    end
  end
end
