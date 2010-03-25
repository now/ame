# -*- coding: utf-8 -*-

module Ame::Types
  def self.register(type, *names)
    names.each do |name|
      types[name] = type
    end
  end

  def self.[](name)
    type = types[name]
    return type if type
    return name if name.respond_to? :parse
    raise ArgumentError, 'Unknown type: %s' % [name]
  end

  def self.types
    @types ||= {}
  end
  private_class_method :types

  require 'ame/types/boolean'
  require 'ame/types/integer'
  require 'ame/types/string'
end
