# -*- coding: utf-8 -*-

# Represents a splat argument to a {Method}, which works just like a normal
# {Argument}, except that it’ll {#process} all remaining arguments and
# therefore has {#arity} = -1.
class Ame::Splat < Ame::Argument
  # @return [Integer] The number of arguments that the receiver processes (-1)
  def arity
    -1
  end

  # Processes each argument in ARGUMENTS via {Argument#process}.
  # @param (see Argument#process)
  # @raise [Ame::MissingArgument] If the receiver is {#required?} and ARGUMENTS
  #   is #empty?
  # @raise [Ame::MalformedArgument] If the receiver couldn’t be parsed or
  #   validated
  # @return [Array<Object>]
  def process(options, processed, arguments)
    super options, processed, nil if required? and arguments.empty?
    arguments.map{ |argument| super(options, processed, argument) }.tap{ arguments.clear }
  end
end
