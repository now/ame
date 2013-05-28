# -*- coding: utf-8 -*-

# Represents a splat argument to a {Method}, which works just like a {Splus},
# except that it won’t fail if there are no more arguments left.
# @api developer
class Ame::Splat < Ame::Splus
  # Processes each argument in ARGUMENTS via {Argument#process}.
  # @api internal
  # @param (see Argument#process)
  # @raise [Ame::MalformedArgument] If the receiver couldn’t be parsed or
  #   validated
  # @return [Array<Object>]
  def process(options, processed, arguments)
    arguments.empty? ? [] : super
  end
end
