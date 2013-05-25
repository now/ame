# -*- coding: utf-8 -*-

class Ame::Arguments::Complete < Ame::Arguments::Undefined
  def initialize(arguments, splat_command, splat)
    @arguments, @splat_command, @splat = arguments + [splat], splat_command, splat
  end

  def argument(name, type, description, &validate)
    error 'argument', name
  end

  def optional(name, default, description, &validate)
    error 'optional', name
  end

  def splat(name, type, description, &validate)
    error 'splat', name
  end

  def splus(name, type, description, &validate)
    error 'splus', name
  end

  private

  def error(command, name)
    raise ArgumentError, "%s '%s', … may not follow %s '%s', …" %
      [command, name, @splat_command, @splat.name]
  end
end
