# -*- coding: utf-8 -*-

class Ame::Splus < Ame::Argument
  def initialize(name, type, description, &validate)
    super name, description, { :type => type }, &validate
  end

  # Processes each argument in ARGUMENTS via {Argument#process}.
  # @param (see Argument#process)
  # @raise [Ame::MissingArgument] If the receiver is {#required?} and ARGUMENTS
  #   is #empty?
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
