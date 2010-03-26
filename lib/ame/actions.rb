# -*- coding: utf-8 -*-

class Ame::Actions
  include Enumerable

  def initialize
    @ordered = []
    @random = {}
  end

  def <<(action)
    @ordered << action
    @random[action.name] = action
    self
  end

  def [](name)
    @random[name]
  end

  def each
    @ordered.each do |action|
      yield action
    end
    self
  end
end
