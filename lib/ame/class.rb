# -*- coding: utf-8 -*-

require 'singleton'

class Ame::Class
  extend SingleForwardable
  include Singleton

  def self.namespace(namespace = nil)
    raise ArgumentError,
      'namespace can only be set from a child of Ame::Class' unless
        namespace.nil? or self.superclass == Ame::Class
    @namespace = namespace.downcase if namespace
    if @namespace.nil? or @namespace.empty?
      @namespace = superclass < Ame::Class ? superclass.namespace + ' ' : ""
      @namespace << name.split('::').last.downcase
    end
    @namespace
  end

  def self.description(description = nil)
    return method.description(description) if description
    @description
  end

  self.def_delegators :method, :options_must_precede_arguments, :option, :argument, :splat

  def process(name, arguments = [])
    methods[name].process arguments
    self
  end

  def call(name, arguments = nil, options = nil)
    methods[name].call arguments, options
    self
  end

private

  def self.method
    @method ||= Ame::Method.new(self)
  end

  def self.methods
    @methods ||= Ame::Methods.new
  end

  def self.method_added(name)
    if name == :initialize
      method.validate
      @description = method.description
    else
      return unless public_instance_methods.map{ |m| m.to_sym }.include? name
      method.name = name
      methods << method if method.validate
    end
    @method = Ame::Method.new(self)
  end

  def self.inherited(subclass)
  end
end
