# -*- coding: utf-8 -*-

class Ame::Methods
  include Enumerable

  def initialize
    @methods = {}
  end

  def <<(method)
    @methods[method.name] = method
    self
  end

  def [](name)
    @methods[name.to_sym] or
      raise Ame::UnrecognizedMethod, 'unrecognized method: %s' % name
  end

  def include?(name)
    @methods.include? name.to_sym
  end

  def each
    @methods.each_value do |method|
      yield method
    end
    self
  end
end
