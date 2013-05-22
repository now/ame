# -*- coding: utf-8 -*-

module Ame::Types::Symbol
  Ame::Types.register self, Symbol

  def self.parse(value)
    value.to_sym
  end
end
