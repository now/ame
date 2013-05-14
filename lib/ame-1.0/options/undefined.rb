# -*- coding: utf-8 -*-

class Ame::Options::Undefined
  def initialize
    @options = {}
    @ordered = []
    @options_must_precede_arguments = ENV.include? 'POSIXLY_CORRECT'
  end

  def options_must_precede_arguments
    @options_must_precede_arguments = true
    self
  end

  def option(name, description, options = {}, &block)
    option = Ame::Option.new(name, description, options, &block)
    self[option.name] = option
    option.aliases.each do |a|
      self[a] = option
    end
    @ordered << option
    self
  end

  def include?(name)
    @options.include? name.to_s
  end

  def define
    Ame::Options.new(@options, @ordered, @options_must_precede_arguments)
  end

  private

  def []=(name, option)
    raise ArgumentError,
      'option already defined: %s' % name if include? name
    @options[name.to_s] = option
  end
end
