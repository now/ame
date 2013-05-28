# -*- coding: utf-8 -*-

# The arguments to a method in its {Method::Undefined undefined state} where a
# splat or splus has been added and thus no further arguments are allowed.
# @api internal
class Ame::Arguments::Complete < Ame::Arguments::Undefined
  def initialize(arguments, splat_command, splat)
    @arguments, @splat_command, @splat = arguments + [splat], splat_command, splat
  end

  # @raise [ArgumentError] If a splat or splus argument has been defined
  def argument(name, type, description, &validate)
    error 'argument', name
  end

  # @raise [ArgumentError] If a splat or splus argument has been defined
  def optional(name, default, description, &validate)
    error 'optional', name
  end

  # @raise [ArgumentError] If a splat or splus argument has been defined
  def splat(name, type, description, &validate)
    error 'splat', name
  end

  # @raise [ArgumentError] If a splat or splus argument has been defined
  def splus(name, type, description, &validate)
    error 'splus', name
  end

  private

  def error(command, name)
    raise ArgumentError, "%s '%s', … may not follow %s '%s', …" %
      [command, name, @splat_command, @splat.name]
  end
end
