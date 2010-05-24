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

  def self.help=(help)
    @@help = help
  end

  def self.help
    @@help ||= Ame::Help::Console.new
  end
  private_class_method :help

  def self.help_for_dispatch(method, subclass)
    help.for_dispatch self, method, subclass
  end

  def self.help_for_method(method)
    help.for_method self, method
  end

  def self.methods
    @methods ||= Ame::Methods.new
  end

  self.def_delegators :method, :options_must_precede_arguments, :option, :argument, :splat

  def process(name, arguments = [])
    self.class.methods[name].process arguments
    self
  end

  def call(name, arguments = nil, options = nil)
    self.class.methods[name].call arguments, options
    self
  end

private

  def self.method
    @method ||= Ame::Method.new(self)
  end
  private_class_method :method

  def self.method_added(name)
    if name == :initialize
      method.validate
      @description = method.description
    elsif public_instance_methods.map{ |m| m.to_sym }.include? name
      method.name = name
      methods << method if method.validate
    elsif (method.validate rescue false)
      raise ArgumentError, 'Non-public method cannot be used by Ame: ' % name
    end
    @method = Ame::Method.new(self)
  end
  private_class_method :method_added

  def self.inherited(subclass)
    @method = Ame::Dispatch.new(self, subclass)
    @method.define
  end
  private_class_method :inherited
end
