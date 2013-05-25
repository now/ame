# -*- coding: utf-8 -*-

# Represents an argument to a {Method}.  It has a {#name} and a {#description}.
# It will be called upon to {#process} an argument before the method this
# argument is associated with gets called.
class Ame::Argument
  # Defines argument NAME of TYPE with DESCRIPTION.  An optional block will be
  # used for any validation or further processing of the parsed value of the
  # argument, where OPTIONS are the options processed so far and their values,
  # PROCESSED are the values of the arguments processed so far, and ARGUMENT is
  # the value itself.
  # @param [String] name
  # @param [Class] type
  # @param [String] description
  # @param [Proc] validate
  # @yield [?]
  # @yieldparam [Hash] options
  # @yieldparam [Array<String>] processed
  # @yieldparam [Object] argument
  def initialize(name, type, description, &validate)
    @name, @description, @validate = name, description, validate || DefaultValidate
    @type = Ame::Types[[type, String].reject(&:nil?).first]
  end

  # @return [String] The name of the receiver
  attr_reader :name

  # @return [String] The description of the receiver
  attr_reader :description

  # Shifts an argument off of ARGUMENTS and parses it as a value of the type of
  # the receiver, then passes this value to the block passed to the receiver’s
  # constructor and returns the result of this block.
  # @raise [Ame::MissingArgument] If ARGUMENTS#empty?
  # @raise [Ame::MalformedArgument] If the argument can’t be parsed or
  #   validated
  # @return [Object]
  def process(options, processed, arguments)
    @validate.call(options, processed, parse(arguments))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end

  # @return [String] The upcasing of the {#name} of the receiver
  def to_s
    name.upcase
  end

  private

  DefaultValidate = proc{ |options, processed, argument| argument }

  def parse(arguments)
    @type.parse(arguments.shift || raise(Ame::MissingArgument, 'missing argument: %s' % self))
  end
end
