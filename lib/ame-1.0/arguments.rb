# -*- coding: utf-8 -*-

# The arguments to a method in its {Method defined state}.  Does the processing
# of arguments to the method and also enumerates {#each} of the arguments to
# the method for, for example, help output.
# @api developer
class Ame::Arguments
  include Enumerable

  def initialize(arguments)
    @arguments = arguments
  end

  # @api internal
  # @param [Hash<String, Object>] options
  # @param [Array<String>] arguments
  # @raise [SuperfluousArgument] If more arguments than required/optional have
  #   been given
  # @raise (see Argument#process)
  # @return [Array<Object>] The {Argument#process}ed arguments
  def process(options, arguments)
    unprocessed = arguments.dup
    reduce([]){ |processed, argument|
      processed << argument.process(options, processed, unprocessed)
    }.tap{
      raise Ame::SuperfluousArgument,
        'superfluous arguments: %s' % unprocessed.join(' ') unless unprocessed.empty?
    }
  end

  # @overload
  #   Enumerates the arguments.
  #
  #   @yieldparam [Argument] argument
  # @overload
  #   @return [Enumerator<Argument>] An Enumerator over the arguments
  def each
    return enum_for(__method__) unless block_given?
    @arguments.each do |argument|
      yield argument
    end
    self
  end
end
