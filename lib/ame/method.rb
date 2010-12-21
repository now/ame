# -*- coding: utf-8 -*-

class Ame::Method
  extend Forwardable

  class << self
    def ruby_name(name)
      name.to_s.gsub('-', '_').to_sym
    end

    def name(name)
      name.to_s.gsub('_', '-').to_sym
    end
  end

  def initialize(klass)
    @class = klass
    @description = nil
  end

  def description(description = nil)
    return @description unless description
    @description = description
    self
  end

  def_delegators :options, :option, :options_must_precede_arguments

  def_delegators :arguments, :argument, :splat, :arity

  def define(name)
    self.name = name
    option 'help', 'Display help for this method' do
      @class.help_for_method self
      throw Ame::AbortAllProcessing
    end unless options.include? 'help'
    self
  end

  def valid?
    not description.nil?
  end

  def process(instance, arguments)
    options, remainder = self.options.process(arguments)
    call(instance, self.arguments.process(options, remainder), options)
  end

  def call(instance, arguments = nil, options = nil)
    options, remainder = self.options.process([]) unless options
    arguments ||= self.arguments.process(options, [])
    instance.send ruby_name, *(arguments + [options])
    self
  end

  attr_reader :name, :ruby_name

  def qualified_name
    [@class.fullname, name.to_s].reject{ |n| n.empty? }.join(' ')
  end

  def options
    @options ||= Ame::Options.new
  end

  def arguments
    @arguments ||= Ame::Arguments.new
  end

private

  def name=(name)
    @ruby_name = name
    @name = self.class.name(name)
  end
end
