# -*- coding: utf-8 -*-

module Ame::Types::String
  Ame::Types.register self, :string

  def self.parse(argument, value)
    value.nil? ? argument.default : value
  end
end
