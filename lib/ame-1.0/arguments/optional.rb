# -*- coding: utf-8 -*-

class Ame::Arguments::Optional < Ame::Arguments::Undefined
  def initialize(arguments, optional)
    @arguments, @optional = arguments + [optional], optional
  end

  def argument(name, type, description, &validate)
    raise ArgumentError,
      "argument '%s', … may not follow optional '%s', …" % [name, @optional.name]
  end

  def splus(name, default, description, &validate)
    raise ArgumentError,
      "splus '%s', … may not follow optional '%s', …" % [name, @optional.name]
  end

  def optional(name, default, description, &validate)
    self << Ame::Optional.new(name, default, description, &validate)
  end
end
