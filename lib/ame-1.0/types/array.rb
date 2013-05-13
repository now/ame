# -*- coding: utf-8 -*-

class Ame::Types::Array
  class << self
    alias_method :[], :new
  end

  def initialize(type)
    @type = Ame::Types[type]
    @contents = []
  end

  def parse(value)
    @contents << @type.parse(value)
  end
end
