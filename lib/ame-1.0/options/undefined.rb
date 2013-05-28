# -*- coding: utf-8 -*-

# The options to a method in its {Method::Undefined undefined state}.
# @api internal
class Ame::Options::Undefined
  def initialize
    @options = {}
    @ordered = []
    @options_must_precede_arguments = ENV.include? 'POSIXLY_CORRECT'
  end

  # Forces options to the method about to be defined to precede any arguments,
  # lest they be seen as arguments.  If not given, the behaviour will depend on
  # whether `ENV['POSIXLY_CORRECT']` has been set or not.
  # @return [self]
  def options_must_precede_arguments
    @options_must_precede_arguments = true
    self
  end

  # Adds a new {Flag} to the receiver.
  # @param (see Flag#initialize)
  # @yield (see Flag#initialize)
  # @yieldparam (see Flag#initialize)
  # @raise (see Flag#initialize)
  # @raise [ArgumentError] If SHORT or LONG have already been defined
  # @return [self]
  def flag(short, long, default, description, &validate)
    self << Ame::Flag.new(short, long, default, description, &validate)
  end

  # Adds a new {Flag} to the receiver.  Also adds a `--no-LONG` flag that’s the
  # inverse of this flag.
  # @param (see Flag#initialize)
  # @yield (see Flag#initialize)
  # @yieldparam (see Flag#initialize)
  # @raise (see Flag#initialize)
  # @raise [ArgumentError] If LONG is #strip#empty?
  # @raise [ArgumentError] If SHORT or LONG have already been defined
  # @return [self]
  def toggle(short, long, default, description, &validate)
    flag = Ame::Flag.new(short, long, default, description, &validate)
    raise ArgumentError, 'long can’t be empty' if flag.long.empty?
    self << flag
    add(Ame::Flag.new('', 'no-%s' % flag.long, nil, description){ |options, argument|
      options[flag.name] = validate ? validate.call(options, !argument) : !argument
    })
  end

  # Adds a new {Switch} to the receiver.
  # @param (see Switch#initialize)
  # @yield (see Switch#initialize)
  # @yieldparam (see Switch#initialize)
  # @raise (see Switch#initialize)
  # @raise [ArgumentError] If SHORT or LONG have already been defined
  # @return [self]
  def switch(short, long, argument, default, argument_default, description, &validate)
    self << Ame::Switch.new(short, long, argument, default, argument_default, description, &validate)
  end

  # Adds a new {Option} to the receiver.
  # @param (see Option#initialize)
  # @yield (see Option#initialize)
  # @yieldparam (see Option#initialize)
  # @raise (see Option#initialize)
  # @raise [ArgumentError] If SHORT or LONG have already been defined
  # @return [self]
  def option(short, long, argument, default, description, &validate)
    self << Ame::Option.new(short, long, argument, default, description, &validate)
  end

  # Adds a new {Multioption} to the receiver.
  # @param (see Multioption#initialize)
  # @yield (see Multioption#initialize)
  # @yieldparam (see Multioption#initialize)
  # @raise (see Multioption#initialize)
  # @raise [ArgumentError] If SHORT or LONG have already been defined
  # @return [self]
  def multioption(short, long, argument, type, description, &validate)
    self << Ame::Multioption.new(short, long, argument, type, description, &validate)
  end

  # @param [String] name
  # @return True if the receiver has any kind of option named NAME
  def include?(name)
    @options.include? name
  end

  # @return [Options] The defined version of the receiver
  def define
    Ame::Options.new(@options, @ordered, @options_must_precede_arguments)
  end

  protected

  def <<(option)
    @ordered << option
    add(option)
  end

  private

  def add(option)
    option.names.each do |name|
      self[name] = option
    end
    self
  end

  def []=(name, option)
    raise ArgumentError, 'option already defined: %s' % name if include? name
    @options[name] = option
  end
end
