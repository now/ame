# -*- coding: utf-8 -*-

require 'singleton'

class Ame::Class
  extend SingleForwardable
  include Singleton

  def self.namespace(options = {})
    @description = options[:description] if options[:description]
    @namespace = options[:name] if options.member? :name
    @namespace = name.gsub('::', ':').downcase if @namespace.nil? or @namespace.empty?
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
    return unless public_instance_methods.map{ |m| m.to_sym }.include? name
    method.name = name
    methods << method if method.validate
    @method = Ame::Method.new(self)
  end

  def self.inherited(subclass)
  end
end
