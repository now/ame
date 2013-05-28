# -*- coding: utf-8 -*-

# Represents an option to a {Method} that takes an optional argument.  If an
# explicit (‘=’-separated) argument is given, it’ll be used, otherwise a
# default value, which differs from the default value used if the option isn’t
# given at all, will be used.
# @api developer
class Ame::Switch < Ame::Flag
  # @api internal
  # @param (see Flag#initialize)
  # @param [String] argument
  # @param [Object] default
  # @param [Object] argument_default
  # @yield (see Flag#initialize)
  # @yieldparam [Hash<String, Object>] options
  # @yieldparam [Object] value
  # @raise (see Flag#initialize)
  # @raise [ArgumentError] If the type of ARGUMENT_DEFAULT or, if
  #   ARGUMENT_DEFAULT is nil, DEFAULT isn’t one that Ame knows how to parse
  def initialize(short, long, argument, default, argument_default, description, &validate)
    @argument = argument.upcase
    @type = Ame::Types[[argument_default, default, String].reject(&:nil?).first]
    @argument_default = @type.respond_to?(:default) ? @type.default : argument_default
    super short, long, default, description, &validate
  end

  # @return [String] The name of the argument to the receiver
  attr_reader :argument

  private

  # @api internal
  # @param (see Flag#parse)
  # @return [Object] The parsed value of EXPLICIT, if non-nil, the default
  #   argument value otherwise
  def parse(arguments, explicit)
    explicit ? @type.parse(explicit) : @argument_default
  end
end
