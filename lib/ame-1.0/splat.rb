# -*- coding: utf-8 -*-

# Represents a splat argument to a {Method}, which works just like a normal
# {Argument}, except that it’ll {#process} all remaining arguments.
class Ame::Splat < Ame::Splus
  # Processes each argument in ARGUMENTS via {Argument#process}.
  # @param (see Argument#process)
  # @raise [Ame::MissingArgument] If the receiver is {#required?} and ARGUMENTS
  #   is #empty?
  # @raise [Ame::MalformedArgument] If the receiver couldn’t be parsed or
  #   validated
  # @return [Array<Object>]
  def process(options, processed, arguments)
    arguments.empty? ? [] : super
  end

  def optional?
    true
  end
end
