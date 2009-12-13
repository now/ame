# -*- coding: utf-8 -*-

class Ame; class Argument; end end

class Ame::Argument::Integer < Ame::Argument
  def parse(argument)
    Integer(argument)
  rescue ArgumentError
    raise Ame::MalformedArgument, "#{self} is not an integer: #{argument}"
  end
end
