# -*- coding: utf-8 -*-

class Ame::Method::Undefined
  def initialize(klass)
    @class = klass
    @description = nil
    @options ||= Ame::Options.new
    @arguments ||= Ame::Arguments.new
  end

  def description(description = nil)
    return @description unless description
    @description = description
    self
  end

  def options_must_precede_arguments
    options.options_must_precede_arguments
    self
  end

  def option(name, description, options = {}, &validate)
    self.options.option name, description, options, &validate
    self
  end

  def argument(name, description, options = {}, &validate)
    arguments.argument name, description, options, &validate
    self
  end

  def splat(name, description, options = {}, &validate)
    arguments.splat name, description, options, &validate
    self
  end

  def arity
    arguments.arity
  end

  def define(ruby_name)
    option :help, 'Display help for this method', :ignore => true do
      @class.help.method @class.methods[Ame::Method.name(ruby_name)]
      throw Ame::AbortAllProcessing
    end unless @options.include? :help
    Ame::Method.new(ruby_name, @class, @description, options, arguments)
  end

  def valid?
    not description.nil?
  end

  attr_reader :options, :arguments
end
