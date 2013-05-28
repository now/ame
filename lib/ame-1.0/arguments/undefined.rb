# -*- coding: utf-8 -*-

# The arguments to a method in its {Method::Undefined undefined state} before
# any optional or splat/splus arguments have been defined.  When an {#optional}
# argument has been added, it’ll enter an {Optional} state where only
# additional {#optional} and {#splat} arguments are allowed.  When a {#splat}
# or {#splus} has been added, it’ll enter a {Complete} state where no
# additional arguments are allowed.
# @api internal
class Ame::Arguments::Undefined
  def initialize
    @arguments = []
  end

  # Adds a new {Argument} to the receiver.
  # @param (see Argument#initialize)
  # @yield (see Argument#initialize)
  # @yieldparam (see Argument#initialize)
  # @raise (see Argument#initialize)
  # @return [self]
  def argument(name, type, description, &validate)
    self << Ame::Argument.new(name, type, description, &validate)
  end

  # Adds a new {Optional} argument to the receiver.
  # @param (see Ame::Optional#initialize)
  # @yield (see Ame::Optional#initialize)
  # @yieldparam (see Ame::Optional#initialize)
  # @raise (see Ame::Optional#initialize)
  # @return [Optional]
  def optional(name, default, description, &validate)
    Ame::Arguments::Optional.new(@arguments, Ame::Optional.new(name, default, description, &validate))
  end

  # Adds a new {Splat} to the receiver.
  # @param (see Argument#initialize)
  # @yield (see Argument#initialize)
  # @yieldparam (see Argument#initialize)
  # @raise (see Argument#initialize)
  # @return [Complete]
  def splat(name, type, description, &validate)
    Ame::Arguments::Complete.new(@arguments, 'splat', Ame::Splat.new(name, type, description, &validate))
  end

  # Adds a new {Splus} (required splat) to the receiver.
  # @param (see Argument#initialize)
  # @yield (see Argument#initialize)
  # @yieldparam (see Argument#initialize)
  # @raise (see Argument#initialize)
  # @return [Complete]
  def splus(name, type, description, &validate)
    Ame::Arguments::Complete.new(@arguments, 'splus', Ame::Splus.new(name, type, description, &validate))
  end

  # @return True if now arguments have been added to the receiver
  def empty?
    @arguments.empty?
  end

  # @return [Arguments] The defined version of the receiver
  def define
    Ame::Arguments.new(@arguments)
  end

  protected

  def <<(argument)
    @arguments << argument
    self
  end
end
