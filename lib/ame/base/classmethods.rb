# -*- coding: utf-8 -*-

module Ame::Base::ClassMethods
  extend Forwardable

  def_delegators :method, :description, :options_must_precede_arguments,
    :option, :argument, :splat

  def methods
    @methods ||= Ame::Methods.new
  end

private

  def method_added(name)
    return unless public_instance_methods.map{ |m| m.to_sym }.include? name
    method.name = name
    methods << method if method.defined?
    @method = Ame::Method.new(self)
  end

  def method
    @method ||= Ame::Method.new(self)
  end
end
