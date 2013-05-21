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
    short = short.strip
    long = long.strip
    options = { :default => !!default }
    options[:ignore] = true if default.nil?
    options[:alias] = short unless long.empty? or short.empty?
    option = Ame::Option.new(long.empty? ? short : long, description, options, &validate)
    self[option.name] = option
    option.aliases.each do |a|
      self[a] = option
    end
    @ordered << option
    self
  end

  def toggle(short, long, default, description, &validate)
    toggle = Ame::Toggle.new(short, long, default, description, &validate)
    toggle.names.each do |name|
      self[name] = toggle
    end
    @ordered << toggle
    self
  end

  def switch(short, long, argument, default, argument_default, description, &validate)
    switch = Ame::Switch.new(short, long, argument, default, argument_default, description, &validate)
    switch.names.each do |name|
      self[name] = switch
    end
    @ordered << switch
    self
  end

  def option(short, long, argument, default, description, &validate)
    short = short.strip
    long = long.strip
    options = { :argument => argument, :default => default }
    options[:alias] = short unless long.empty? or short.empty?
    option = Ame::Option.new(long.empty? ? short : long, description, options, &validate)
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
