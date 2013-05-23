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
  def argument(name, description, options = {}, &block)
    self << Ame::Argument.new(name, description, options, &block)
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
    self.splat = Ame::Splat.new(name, description, options, &validate)
    self
  end

  def splus(name, default, description, &validate)
    self.splat = Ame::Splus.new(name, default, description, &validate)
    self
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
    raise ArgumentError,
      'argument %s must come before splat argument %s' %
        [argument.name, @splat.name] if @splat
    @arguments << argument
    self
  end

  def splat=(splat)
    raise ArgumentError,
      'splat argument %s already defined: %s' % [@splat.name, splat.name] if @splat
    @splat = splat
  end

  private

  def first_optional
    @arguments.find{ |a| a.optional? }
  end

  module Optional
    def splus(name, default, description, &validate)
      super
      raise ArgumentError,
        'splus “%s” may not follow optional “%s”' %
          [@splat.name, @optional.name]
    end

    def argument(name, description, options = {}, &block)
      raise ArgumentError,
        'optional argument %s may not precede required argument %s' %
          [@optional.name, name]
    end
  end
end
