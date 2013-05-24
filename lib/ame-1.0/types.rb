# -*- coding: utf-8 -*-

module Ame::Types
  class << self
    def register(type, *classes)
      classes.each do |c|
        types[c] = type
      end
    end

    def [](class_or_value)
      type = types[class_or_value] and return type
      pair = types.find{ |c, t| class_or_value.is_a? c } and return pair.last
      class_or_value.respond_to? :parse and return class_or_value
      raise ArgumentError, 'unknown type: %p' % [class_or_value]
    end

  private

    def types
      @types ||= {}
    end
  end
end
