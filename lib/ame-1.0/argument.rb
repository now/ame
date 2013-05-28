# -*- coding: utf-8 -*-

# Represents an argument to a {Method}.  It has a {#name} and a {#description}.
# It will be called upon to process an argument before the method this argument
# is associated with gets called.
# @api developer
class Ame::Argument
  # @api internal
  # @param [String] name
  # @param [::Class] type
  # @param [String] description
  # @yield [?]
  # @yieldparam [Hash<String, Object>] options
  # @yieldparam [Array<String>] processed
  # @yieldparam [Object] argument
  # @raise [ArgumentError] If TYPE isn’t one that Ame knows how to parse
  def initialize(name, type, description, &validate)
    @name, @description, @validate = name, description, validate || proc{ |_, _, a| a }
    @type = Ame::Types[[type, String].reject(&:nil?).first]
  end

  # @return [String] The name of the receiver
  attr_reader :name

  # @return [String] The description of the receiver
  attr_reader :description

  # @return [String] The upcasing of the {#name} of the receiver
  def to_s
    @to_s ||= name.upcase
  end

  # Invokes the optional block passed to the receiver when it was created for
  # additional validation and parsing after optionally parsing one or more of
  # the ARGUMENTS passed to it (see subclasses’ {#parse} methods for their
  # behaviour).
  # @api internal
  # @param [Hash<String, Object>] options
  # @param [Array<String>] processed
  # @param [Array<String>] arguments
  # @raise [MissingArgument] If a required argument is missing
  # @raise [MalformedArgument] If an argument can’t be parsed
  # @return [Object]
  def process(options, processed, arguments)
    @validate.call(options, processed, parse(arguments))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end

  private

  # Returns the parsed value of the result of ARGUMENTS#shift
  # Should be overridden by subclasses that want different behaviour for
  # missing arguments.
  # @api internal
  # @param [Array<String>] arguments
  # @return [Object] The parsed value of the result of ARGUMENTS#shift
  # @raise [MissingArgument] If ARGUMENTS#empty?
  # @raise [MalformedArgument] If ARGUMENTS#shift is non-nil and can’t be parsed
  def parse(arguments)
    @type.parse(arguments.shift || raise(Ame::MissingArgument, 'missing argument: %s' % self))
  end
end
