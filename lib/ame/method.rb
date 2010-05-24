# -*- coding: utf-8 -*-

class Ame::Method
  extend Forwardable

  def initialize(klass)
    @class = klass
    @description = nil
    @called = false
    option 'help', 'Display help for this method'
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
    true
  end

  def process(arguments)
    return self if @called
    options, remainder = self.options.process(arguments)
    return self if possibly_display_help(options)
    call(self.arguments.process(options, remainder), options)
  end

  def call(arguments = nil, options = nil)
    return self if @called
    options, remainder = self.options.process([]) unless options
    return self if possibly_display_help(options)
    arguments ||= self.arguments.process(options, [])
    arguments << options
    @class.instance.send ruby_name, *arguments
    @called = true
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

private

  def possibly_display_help(options)
    return false unless options['help']
    help
    true
  end

  def help
    @class.help_for_method self
  end
end
