# -*- coding: utf-8 -*-

# Stores {Methods#each #each} {Method} defined on a {Class}.
# @api developer
class Ame::Methods
  include Enumerable

  def initialize
    @methods = {}
  end

  # Adds METHOD to the receiver
  # @param [Method] method
  # @return [self]
  def <<(method)
    @methods[method.name] = method
    self
  end

  # @return [Method] The method NAME in the receiver
  # @raise [UnrecognizedMethod] If NAME isn’t a method in the receiver
  def [](name)
    @methods[name] or
      raise Ame::UnrecognizedMethod, 'unrecognized method: %s' % name
  end

  # @overload
  #   Enumerates the methods.
  #
  #   @yieldparam [Method] option
  # @overload
  #   @return [Enumerator<Method>] An Enumerator over the methods
  def each
    return enum_for(__method__) unless block_given?
    @methods.each_value do |method|
      yield method
    end
    self
  end
end
