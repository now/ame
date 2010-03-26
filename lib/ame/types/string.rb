# -*- coding: utf-8 -*-

module Ame::Types::String
  Ame::Types.register self, String

  def self.parse(argument, value)
    value.nil? ? argument.default : value
  end
end