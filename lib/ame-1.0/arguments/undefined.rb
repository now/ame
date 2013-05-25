# -*- coding: utf-8 -*-

class Ame::Arguments::Undefined
  def initialize
    @arguments = []
  end

  # Defines argument NAME with DESCRIPTION of TYPE, which, if OPTIONAL, has
  # DEFAULT as its value if not given.  An optional block will be used for any
  # validation or further processing, where OPTIONS are the options processed
  # so far and their values, PROCESSED are the values of the arguments
  # processed so far, and ARGUMENT is the value of the argument itself.
  # @param (see Argument#initialize)
  # @option (see Argument#initialize)
  # @yield (see Argument#initialize)
  # @yieldparam (see Argument#initialize)
  # @raise [ArgumentError] If a splat argument has been defined
  # @raise [ArgumentError] If an OPTIONAL argument has been defined and this
  #   one isn’t
  # @raise (see Argument#initialize)
  # @return [self]
  def argument(name, type, description, &validate)
    self << Ame::Argument.new(name, type, description, &validate)
  end

  def optional(name, default, description, &validate)
    Ame::Arguments::Optional.new(@arguments, Ame::Optional.new(name, default, description, &validate))
  end

  # Defines splat argument NAME with DESCRIPTION of TYPE, which, if OPTIONAL,
  # has DEFAULT as its value if not given, or returns the splat argument, if
  # NAME is nil.  An optional block will be used for any validation or further
  # processing, where OPTIONS are the options processed so far and their
  # values, PROCESSED are the values of the arguments processed so far, and
  # ARGUMENT is the value of the argument itself.
  # @param (see Argument#initialize)
  # @option (see Argument#initialize)
  # @yield (see Argument#initialize)
  # @yieldparam (see Argument#initialize)
  # @raise (see Argument#initialize)
  # @return [Splat, self]
  def splat(name, type, description, &validate)
    Ame::Arguments::Complete.new(@arguments, 'splat', Ame::Splat.new(name, type, description, &validate))
  end

  def splus(name, type, description, &validate)
    Ame::Arguments::Complete.new(@arguments, 'splus', Ame::Splus.new(name, type, description, &validate))
  end

  def empty?
    @arguments.empty?
  end

  def define
    Ame::Arguments.new(@arguments)
  end

  protected

  def <<(argument)
    @arguments << argument
    self
  end
end
