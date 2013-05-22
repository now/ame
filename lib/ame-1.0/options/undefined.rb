# -*- coding: utf-8 -*-

# The options to a method in its undefined state.
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

  def flag(short, long, default, description, &validate)
    self << Ame::Flag.new(short, long, default, description, &validate)
  end

  def toggle(short, long, default, description, &validate)
    flag = Ame::Flag.new(short, long, default, description, &validate)
    raise ArgumentError if flag.long.empty?
    self << flag
    add Ame::Flag.new '', 'no-%s' % flag.long, nil, description do |options, argument|
      options[flag.name] = validate ? validate.call(options, !argument) : !argument
    end
  end

  def switch(short, long, argument, default, argument_default, description, &validate)
    self << Ame::Switch.new(short, long, argument, default, argument_default, description, &validate)
  end

  def option(short, long, argument, default, description, &validate)
    self << Ame::Option.new(short, long, argument, default, description, &validate)
  end

  def include?(name)
    @options.include? name.to_s
  end

  def define
    Ame::Options.new(@options, @ordered, @options_must_precede_arguments)
  end

  protected

  def <<(option)
    add option
    @ordered << option
    self
  end

  private

  def add(option)
    option.names.each do |name|
      self[name] = option
    end
    self
  end

  def []=(name, option)
    raise ArgumentError,
      'option already defined: %s' % name if include? name
    @options[name.to_s] = option
  end
end
