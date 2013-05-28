# -*- coding: utf-8 -*-

# Represents a boolean option to a {Method} that doesn’t take an argument,
# though an argument is actually allowed if it’s made explicit by following the
# option name with a ‘=’ character and the argument value.  Does the potential
# processing of the argument or simply returns the inverse {#default} value of
# the flag.
# @api developer
class Ame::Flag
  # @api internal
  # @param [String] short
  # @param [String] long
  # @param [Boolean] default
  # @param [String] description
  # @yield [?]
  # @yieldparam [Hash<String, Object>] options
  # @yieldparam [Boolean] value
  # @raise [ArgumentError] If SHORT and LONG are #strip#empty?
  # @raise [ArgumentError] If SHORT#strip#length > 1
  def initialize(short, long, default, description, &validate)
    @short, @long, @default, @description, @validate =
      (s = short.strip).empty? ? nil : s, (l = long.strip).empty? ? nil : l,
      default, description, validate || proc{ |_, a| a }
    raise ArgumentError, 'both short and long can’t be empty' if
      @short.nil? and @long.nil?
    raise ArgumentError, 'short can’t be longer than 1: %s' % @short if
      @short and @short.length > 1
  end

  # Invokes the optional block passed to the receiver when it was created for
  # additional validation and parsing after optionally parsing one or more of
  # the ARGUMENTS passed to it (see subclasses’ {#parse} methods for their
  # behaviour).
  # @api internal
  # @param [Hash<String, Object>] options
  # @param [Array<String>] arguments
  # @param [String] name
  # @raise [MissingArgument] If a required argument to an option is missing
  # @raise [MalformedArgument] If an argument to an option can’t be parsed
  # @return [Boolean]
  def process(options, arguments, name, explicit)
    @validate.call(options, parse(arguments, explicit))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [name, e]
  end

  # Invokes {#process} with arguments depending on whether REMAINDER, which is
  # any content following a short option, should be seen as an argument to the
  # receiver or not (see subclasses’ {#process_combined} methods for their
  # behaviour), returning the result of {#process} and REMAINDER if it was
  # used, or an empty String if it was.
  # @api internal
  # @param (see #process)
  # @param [String] remainder
  # @return [[Boolean, String]]
  def process_combined(options, arguments, name, remainder)
    [process(options, arguments, name, nil), remainder]
  end

  # @return [String] The long or short name of the option
  def name
    @name ||= names.first
  end

  # @return [Array<String>] The long and/or short name of the option
  def names
    @names ||= [long, short].reject{ |e| e.nil? }
  end

  # @return True if the receiver shouldn’t be included in the Hash of option
  #   names and their values
  def ignored?
    default.nil?
  end

  # @return [String] The short name of the receiver
  attr_reader :short

  # @return [String] The long name of the receiver
  attr_reader :long

  # @return [Boolean] The default value of the receiver
  attr_reader :default

  # @return [String] The description of the receiver
  attr_reader :description

  private

  # Returns the parsed value of EXPLICIT, or the inverse of {#default} if nil.
  # Should be overridden by subclasses that want different behaviour for
  # missing arguments.
  # @api internal
  # @param [Array<String>] arguments
  # @param [String, nil] explicit
  # @return [Boolean]
  # @raise [MalformedArgument] If EXPLICIT is non-nil and can’t be parsed
  def parse(arguments, explicit)
    explicit ? Ame::Types[TrueClass].parse(explicit) : !default
  end
end
