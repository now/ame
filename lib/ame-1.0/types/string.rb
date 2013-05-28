# -*- coding: utf-8 -*-

module Ame::Types::String
  Ame::Types.register self, String

  def self.parse(argument)
    argument
  end
end
