# -*- coding: utf-8 -*-

# Represents an argument to a {Method}.  It has a {#name}, a {#description}, it
# may be {#optional?}, in which case it might have a {#default}, otherwise it’s
# {#required?}.  It may be called upon to {#process} an argument before the
# method this argument is associated with gets called.
class Ame::Argument
  # Defines argument NAME with DESCRIPTION of TYPE, which, if OPTIONAL, has
  # DEFAULT as its value if not given.  An optional block will be used for any
  # validation or further processing, where OPTIONS are the options processed
  # so far and their values, PROCESSED are the values of the arguments
  # processed so far, and ARGUMENT is the value of the argument itself.
  # @param [#to_sym] name
  # @param [String] description
  # @param [Hash] options
  # @param [Proc] validate
  # @option options [Module] :type (type of options[:default] or String) The
  #   type of the argument
  # @option options [Object] :optional (false) True if the argument is optional
  # @option options [Object] :default The default to use if the argument
  #   isn’t specified
  # @yield [?]
  # @yieldparam [Hash] options
  # @yieldparam [Array<String>] processed
  # @yieldparam [Object] argument
  # @raise [ArgumentError] If DEFAULT given but OPTIONAL is false
  # @raise [ArgumentError] If DEFAULT isn’t of TYPE
  def initialize(name, type, description, &validate)
    @name, @description, @validate = name.to_sym, description, validate || DefaultValidate
    @type = Ame::Types[[type, String].reject(&:nil?).first]
  end

  # @return [Symbol] The name of the receiver
  attr_reader :name

  # @return [String] The description of the receiver
  attr_reader :description

  # Parses ARGUMENT as a value of the type of the receiver, then passes this
  # value to the block passed to the receiver’s constructor and returns the
  # result of this block.
  # @raise [Ame::MissingArgument] If the receiver is {#required?} and ARGUMENT
  #   is nil
  # @raise [Ame::MalformedArgument] If the receiver couldn’t be parsed or
  #   validated
  # @return [Object]
  def process(options, processed, arguments)
    @validate.call(options, processed, parse(arguments))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end

  # @return [String] The upcasing of the {#name} of the receiver
  def to_s
    name.to_s.upcase
  end

  private

  DefaultValidate = proc{ |options, processed, argument| argument }

  def parse(arguments)
    @type.parse(arguments.shift || raise(Ame::MissingArgument, 'missing argument: %s' % self))
  end
end
