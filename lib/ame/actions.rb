# -*- coding: utf-8 -*-

class Ame; end

class Ame::Actions
  include Enumerable

  def initialize
    @order = []
    @actions = {}
  end

  def []=(key, value)
    @order << key
    @actions[key] = value
  end

  def each
    @order.each do |key|
      yield key, value
    end
    self
  end
end
