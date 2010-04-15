# -*- coding: utf-8 -*-

module Ame::Classes
  extend Enumerable

  def self.<<(subclass)
    subclasses << subclass
  end

  def self.[](name)
    namespace = name.to_s.downcase
    subclasses.find{ |s| s.namespace == namespace }
  end

  def self.method(name, default)
    parts = name.to_s.split(':')
    raise ArgumentError, 'Method name missing' if parts.empty?
    method_name = parts.pop.gsub('-', '_').to_sym
    class_name = parts.join(':')
    subclass = class_name.empty? ? default : self[class_name]
    raise ArgumentError, 'Undefined namespace %s' % class_name unless subclass
    method = subclass.methods[method_name]
    raise ArgumentError, 'Undefined method %s' % [name] unless method
    method
  end

  def self.each
    subclasses.each do |subclass|
      yield subclass
    end
    self
  end

private

  def self.subclasses
    @subclasses ||= []
  end
end
