# -*- coding: utf-8 -*-

# Represents an option to a {Method} that takes an argument.  If an explicit
# (‘=’-separated) argument is given, it’ll be used, otherwise the following
# argument will be used.
# @api developer
class Ame::Option < Ame::Switch
  # @api internal
  # @param (see Switch#initialize)
  # @yield (see Switch#initialize)
  # @yieldparam (see Switch#initialize)
  # @raise (see Flag#initialize)
  # @raise [ArgumentError] If the type of DEFAULT isn’t one that Ame knows how
  #   to parse
  def initialize(short, long, argument, default, description, &validate)
    super short, long, argument, default, nil, description, &validate
  end

  # Invokes {Flag#process} with REMAINDER as the explicit argument if it’s
  # non-empty.
  # @api internal
  # @param (see Flag#process_combined)
  # @return [[Boolean, '']]
  def process_combined(options, arguments, name, remainder)
    [process(options, arguments, name, remainder.empty? ? nil : remainder), '']
  end

  private

  # @api internal
  # @param (see Flag#parse)
  # @return [Object] The parsed value of EXPLICIT, if non-nil, the next argument otherwise
  # @raise [MissingArgument] If EXPLICIT is nil and there are no more arguments
  def parse(arguments, explicit)
    @type.parse(explicit || arguments.shift || raise(Ame::MissingArgument, 'missing argument: %s' % self))
  end
end
