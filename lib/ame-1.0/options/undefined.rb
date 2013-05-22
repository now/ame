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
    flag = Ame::Flag.new(short, long, default, description, &validate)
    flag.names.each do |name|
      self[name] = flag
    end
    @ordered << flag
    self
  end

  def toggle(short, long, default, description, &validate)
    flag = Ame::Flag.new(short, long, default, description, &validate)
    raise ArgumentError if flag.long.empty?
    flag.names.each do |name|
      self[name] = flag
    end
    @ordered << flag
    noflag = Ame::Flag.new '', 'no-%s' % long, nil, description do |options, argument|
      options[flag.name] = validate ? validate.call(options, !argument) : !argument
    end
    noflag.names.each do |name|
      self[name] = noflag
    end
    self
  end

  def switch(short, long, argument, default, argument_default, description, &validate)
    switch = Ame::Switch.new(short, long, argument, default, argument_default, description, &validate)
    switch.names do |name|
      self[name] = switch
    end
    @ordered << switch
    self
  end

  def option(short, long, argument, default, description, &validate)
    option = Ame::Option.new(short, long, argument, default, description, &validate)
    self[option.name] = option
    option.names do |a|
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
