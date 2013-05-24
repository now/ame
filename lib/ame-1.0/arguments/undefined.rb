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
    add('argument', Ame::Argument.new(name, type, description, &validate))
  end

  def optional(name, default, description, &validate)
    add('optional', Ame::Optional.new(name, default, description, &validate).tap{ |o| @optional ||= o })
    extend(Optional)
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
    splatify('splat', Ame::Splat.new(name, type, description, &validate))
  end

  def splus(name, type, description, &validate)
    splatify('splus', Ame::Splus.new(name, type, description, &validate))
  end

  def empty?
    @arguments.empty?
  end

  def define
    Ame::Arguments.new(@arguments)
  end

  protected

  def add(command, argument)
    @arguments << argument
    self
  end

  def splatify(command, splat)
    @splat_command ||= command
    @splat ||= splat
    add(command, splat)
    extend(Splat)
  end

  private

  module Optional
    def argument(name, description, options = {}, &validate)
      raise ArgumentError,
        "argument '%s', … may not follow optional '%s', …" %
          [@optional.name, name]
    end

    def splus(name, default, description, &validate)
      super
      raise ArgumentError,
        "splus '%s', … may not follow optional '%s', …" %
          [@splat.name, @optional.name]
    end
  end

  module Splat
    def add(command, argument)
      raise ArgumentError,
        "%s '%s', … may not follow %s '%s', …" %
          [command, argument.name, @splat_command, @splat.name]
    end
  end
end
