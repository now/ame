# -*- coding: utf-8 -*-

# Enumeration type for limiting a Symbol argument to one in a fixed set.  It
# also has a {#default}, which will be the first symbol passed to its
# constructor.
# @example Using an Enumeration
#   class Git::CLI::Git::FormatPatch < Ame::Class
#     switch '', 'thread', 'STYLE', nil,
#       Ame::Types::Enumeration[:shallow, :deep],
#       'Controls addition of In-Reply-To and References headers'
class Ame::Types::Enumeration
  class << self
    # Alias for .new.
    alias [] new
  end

  # Creates an Enumeration of valid Symbols FIRST, SECOND, and REST for an
  # argument and sets {#default} to FIRST.
  # @param [#to_sym] first
  # @param [#to_sym] second
  # @param [#to_sym, …] rest
  def initialize(first, second, *rest)
    @default = first
    @names = ([first, second] + rest).map(&:to_sym)
  end

  # @api internal
  # @param [String] argument
  # @return [Symbol] The result of ARGUMENT#to_sym
  # @raise [MalformedArgument] If ARGUMENT#to_sym isn’t included among the
  #   valid Symbols
  def parse(argument)
    @names.include?(s = argument.to_sym) ? s :
      raise(Ame::MalformedArgument, 'must be one of %s, not %s' %
            [@names.join(', '), argument])
  end

  # @return [Symbol] The Symbol to use if no argument has been given
  attr_reader :default
end
