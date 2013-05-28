# -*- coding: utf-8 -*-

# Represents a splus argument to a {Method}, which works just like a normal
# {Argument}, except that it’ll process all remaining arguments.
# @api developer
class Ame::Splus < Ame::Argument
  # Processes each argument in ARGUMENTS via {Argument#process}.
  # @api internal
  # @param (see Argument#process)
  # @raise [Ame::MissingArgument] If ARGUMENTS#empty?
  # @raise [Ame::MalformedArgument] If the receiver couldn’t be parsed or
  #   validated
  # @return [Array<Object>]
  def process(options, processed, arguments)
    super options, processed, arguments if arguments.empty?
    [].tap{ |r|
      until arguments.empty?
        r << super(options, processed, arguments)
      end
    }
  end
end
