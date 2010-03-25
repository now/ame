# -*- coding: utf-8 -*-

module Ame::Types::Boolean
  Ame::Types.register self, :boolean

  def self.parse(argument, value)
    case value
    when nil
      not argument.default
    when 'true', 'yes', 'on'
      true
    when 'false', 'no', 'off'
      false
    else
      raise Ame::MalformedArgument, "#{argument} is not a boolean: #{value}"
    end
  end
end
