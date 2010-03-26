# -*- coding: utf-8 -*-

module Ame::Types
  def self.register(type, *classes)
    classes.each do |c|
      types[c] = type
    end
  end

  def self.[](class_or_value)
    type = types[class_or_value] and return type
    pair = types.find{ |c, t| class_or_value.is_a? c } and return pair.last
    class_or_value.respond_to? :parse and return class_or_value
    raise ArgumentError, 'Unknown type: %s' % class_or_value
  end

  def self.types
    @types ||= {}
  end
  private_class_method :types

  require 'ame/types/boolean'
  require 'ame/types/integer'
  require 'ame/types/string'
end