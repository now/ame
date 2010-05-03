# -*- coding: utf-8 -*-

class Ame::Methods
  extend Forwardable
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
    @random[name.to_sym]
  end

  def_delegators :@random, :include?

  def each
    @ordered.each do |method|
      yield method
    end
    self
  end
end
