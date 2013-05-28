# -*- coding: utf-8 -*-

module Ame::Types::Boolean
  Ame::Types.register self, TrueClass, FalseClass

  def self.parse(argument)
    case argument
    when 'true', 'yes', 'on' then true
    when 'false', 'no', 'off' then false
    else raise Ame::MalformedArgument, 'not a boolean: %s' % argument
    end
  end
end
