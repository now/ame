# -*- coding: utf-8 -*-

class Ame::Method
  extend Forwardable

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

  def validate
    raise ArgumentError,
      'method lacks description: %s' % ruby_name unless description
    option 'help', 'Display help for this method' do
      @class.help_for_method self
      throw Ame::AbortAllProcessing
    end unless options.include? 'help'
    self
  end

  def process(instance, arguments)
    options, remainder = self.options.process(arguments)
    call(instance, self.arguments.process(options, remainder), options)
  end

  def call(instance, arguments = nil, options = nil)
    options, remainder = self.options.process([]) unless options
    arguments ||= self.arguments.process(options, [])
    arguments << options
    instance.send ruby_name, *arguments
    self
  end

  def name=(name)
    @ruby_name = name
    @name = name.to_s.gsub('_', '-').to_sym
  end

  attr_reader :name, :ruby_name

  def options
    @options ||= Ame::Options.new
  end

  def arguments
    @arguments ||= Ame::Arguments.new
  end
end
