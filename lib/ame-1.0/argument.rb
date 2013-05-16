# -*- coding: utf-8 -*-

# Represents an argument to a {Method}.  It has a {#name}, a {#description}, it
# may be {#optional?}, in which case it might have a {#default}, otherwise it’s
# {#required?}, and it has an {#arity} of 1 ({Splat} has an {Splat#arity?
# arity} of -1).  It may be called upon to {#process} an argument before the
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
  def initialize(name, description, options = {}, &validate)
    @name, @description, @validate = name.to_sym, description, validate || DefaultValidate
    @optional = options.fetch(:optional, false)
    @type = Ame::Types[[options[:type], options[:default], String].find{ |o| !o.nil? }]
    set_default options[:default], options[:type] if options.include? :default
  end

  # @return [Symbol] The name of the receiver
  attr_reader :name

  # @return [String] The description of the receiver
  attr_reader :description

  # @return [Object, nil] The default value of the receiver
  attr_reader :default

  # @return True if the receiver doesn’t have to appear for the method to be
  #   called
  def optional?
    @optional
  end

  # @return True if the receiver has to appear for the method to be called
  def required?
    not optional?
  end

  # @return [Integer] The number of arguments that the receiver processes (1)
  def arity
    1
  end

  # Parses ARGUMENT as a value of the type of the receiver, then passes this
  # value to the block passed to the receiver’s constructor and returns the
  # result of this block.
  # @raise [Ame::MissingArgument] If the receiver is {#required?} and ARGUMENT
  #   is nil
  # @raise [Ame::MalformedArgument] If the receiver couldn’t be parsed or
  #   validated
  # @return [Object]
  def process(options, processed, argument)
    raise Ame::MissingArgument, 'missing argument: %s' % self if required? and argument.nil?
    @validate.call(options, processed, argument.nil? ? default : @type.parse(argument))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end

  # @return [String] The upcasing of the {#name} of the receiver
  def to_s
    name.to_s.upcase
  end

  private

  DefaultValidate = proc{ |options, processed, argument| argument }

  def set_default(value, type)
    raise ArgumentError,
      'default value can only be set if optional' unless optional?
    raise ArgumentError,
      'default value %s is not of type %s' %
        [value, type] unless value.nil? or type.nil? or value.is_a? type
    @default = value
  end
end
