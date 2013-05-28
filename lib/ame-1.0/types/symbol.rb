# -*- coding: utf-8 -*-

module Ame::Types::Symbol
  Ame::Types.register self, Symbol

  def self.parse(argument)
    argument.to_sym
  end
end
