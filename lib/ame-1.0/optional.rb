# -*- coding: utf-8 -*-

# Represents an optional argument to a {Method}.  It has a {#default} value
# that will be used if no more arguments are available when it gets called upon
# to process an argument before the method this argument is associated with
# gets called.
# @api developer
class Ame::Optional < Ame::Argument
  # @api internal
  # @param (see Argument#initialize)
  # @param [Object] default
  # @yield (see Argument#initialize)
  # @yieldparam (see Argument#initialize)
  # @raise [ArgumentError] If the type of DEFAULT isn’t one that Ame knows how
  #   to parse
  def initialize(name, default, description, &validate)
    @default = default
    super
  end

  # @return [Object, nil] The default value of the receiver
  attr_reader :default

  private

  # @api internal
  # @return [Object] {#default} if ARGUMENTS#empty?, {super} otherwise
  def parse(arguments)
    arguments.empty? ? default : super
  end
end
