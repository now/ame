# -*- coding: utf-8 -*-

class Ame::Arguments::Undefined
  def initialize
    @arguments, @splat = [], nil
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
  def argument(name, description, options = {}, &validate)
    self << Ame::Argument.new(name, description, options, &validate)
  end

  def optional(name, default, description, &validate)
    self << @optional = Ame::Optional.new(name, default, description, &validate)
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
  def splat(name, description, options = {}, &validate)
    splatify(Ame::Splat.new(name, description, options, &validate), 'splat')
  end

  def splus(name, default, description, &validate)
    splatify(Ame::Splus.new(name, default, description, &validate), 'splus')
  end

  def empty?
    @arguments.empty? and not @splat
  end

  def define
    @arguments << @splat if @splat
    Ame::Arguments.new(@arguments)
  end

  protected

  def <<(argument)
    @arguments << argument
    self
  end

  def splatify(splat, command)
    extend(Splat)
    @splat = splat
    @splat_command = command
    self
  end

  private

  module Optional
    def splus(name, default, description, &validate)
      super
      raise ArgumentError,
        "splus '%s', … must come before optional '%s', …" %
          [@splat.name, @optional.name]
    end

    def argument(name, description, options = {}, &validate)
      raise ArgumentError,
        "argument '%s', … must come before optional '%s', …" %
          [@optional.name, name]
    end
  end

  module Splat
    def argument(name, description, options = {}, &validate)
      raise ArgumentError,
        "argument '%s', … must come before %s '%s', …" %
          [name, @splat_command, @splat.name]
    end

    def optional(name, default, description, &validate)
      raise ArgumentError,
        "optional '%s', … must come before %s '%s', …" %
          [name, @splat_command, @splat.name]
    end

    def splatify(splat, command)
      raise ArgumentError,
        "%s '%s', … may not follow %s '%s', …" %
          [command, splat.name, @splat_command, @splat.name]
    end
  end
end
