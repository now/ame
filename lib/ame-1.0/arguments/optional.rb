# -*- coding: utf-8 -*-

# The arguments to a method in its {Method::Undefined undefined state} where at
# least one optional argument has been defined and only further
# {Optional#optional #optional} or {Undefined#splat #splat} arguments are
# allowed.
# @api internal
class Ame::Arguments::Optional < Ame::Arguments::Undefined
  def initialize(arguments, optional)
    @arguments, @optional = arguments + [optional], optional
  end

  # @raise [ArgumentError] If an optional argument has been defined
  def argument(name, type, description, &validate)
    raise ArgumentError,
      "argument '%s', … may not follow optional '%s', …" % [name, @optional.name]
  end

  # @raise [ArgumentError] If an optional argument has been defined
  def splus(name, default, description, &validate)
    raise ArgumentError,
      "splus '%s', … may not follow optional '%s', …" % [name, @optional.name]
  end

  # Adds a new {Optional} argument to the receiver.
  # @param (see Undefined#optional)
  # @yield (see Undefined#optional)
  # @yieldparam (see Undefined#optional)
  # @raise (see Undefined#optional)
  # @return [self]
  def optional(name, default, description, &validate)
    self << Ame::Optional.new(name, default, description, &validate)
  end
end
