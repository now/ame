# -*- coding: utf-8 -*-

require 'singleton'

class Ame::Class
  include Singleton

  # TODO: Don’t we want this to be thrown all the way to the top level?
  # So, only catch if our #superclass is Ame::Class.  Perhaps set up
  # Ame::AbortAllProcessing.
  def process(name, arguments = [])
    catch Ame::AbortProcessing do
      self.class.methods[name].process arguments
    end
    self
  end

  def call(name, arguments = nil, options = nil)
    catch Ame::AbortProcessing do
      self.class.methods[name].call arguments, options
    end
    self
  end

  class << self
    extend Forwardable

    def namespace(namespace = nil)
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

    def description(description = nil)
      return method.description(description) if description
      @description
    end

    def help=(help)
      @@help = help
    end

    def help_for_dispatch(method, subclass)
      help.for_dispatch self, method, subclass
    end

    def help_for_method(method)
      help.for_method self, method
    end

    def methods
      @methods ||= Ame::Methods.new
    end

  private

    def help
      @@help ||= Ame::Help::Console.new
    end

    def method
      @method ||= Ame::Method.new(self)
    end

    def method_added(name)
      if name == :initialize
        method.validate
        @description = method.description
        Ame::Dispatch.new(superclass, self).define
      elsif public_instance_methods.map{ |m| m.to_sym }.include? name
        method.name = name
        methods << method if method.validate
      elsif (method.validate rescue false)
        raise ArgumentError, 'non-public method cannot be used by Ame: ' % name
      end
      @method = Ame::Method.new(self)
    end

    def_delegators :method, :options_must_precede_arguments, :option, :argument, :splat
  end
end
