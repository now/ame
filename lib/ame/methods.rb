# -*- coding: utf-8 -*-

class Ame::Methods
  include Enumerable

  def initialize
    @ordered = []
    @random = {}
  end

  def <<(method)
    @ordered << method
    @random[method.name] = method
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
