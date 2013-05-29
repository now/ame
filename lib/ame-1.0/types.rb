# -*- coding: utf-8 -*-

# Types registered with Ame for parsing command-line arguments into Ruby
# values.  By default, Ruby classes TrueClass, FalseClass, Float, Integer,
# String, and Symbol are registered, as well as an {Enumeration} type for
# limiting a Symbol to one of a fixed set.
module Ame::Types
  @types = {}

  class << self
    # Registers TYPE for parsing command-line arguments for Ruby values whose
    # class is any of CLASSES.  The TYPE should respond to #parse(String),
    # which should convert its String argument into a Ruby value, and may
    # optionally respond to #default, which should return the default value of
    # the TYPE, if any.
    # @param [#parse, #default] type
    # @param [::Class, …] classes
    # @return [self]
    # @example Registering a New Type
    #   require 'pathname'
    #
    #   module My::Pathname
    #     Ame::Types.register self, Pathname
    #
    #     def parse(argument)
    #       Pathname(argument)
    #     end
    #   end
    # @example Using a New Type as a Type
    #   class Rm < Ame::Root
    #     …
    #     splus 'FILE', My::Pathname, 'File to remove'
    #     def rm(pathnames)
    #       pathnames.each do |e| e.rmtree end
    #     end
    #   end
    # @example Using a New Types as a Default
    #   class My < Ame::Root
    #     optional 'CONFIG', Pathname('/etc/my/config'), 'Configuration file to use'
    def register(type, *classes)
      classes.each do |c|
        @types[c] = type
      end
      self
    end

    # @api developer
    # @return [Object] The type registered to parse arguments into values of
    #   CLASS_OR_VALUE or of the class of CLASS_OR_VALUE, alternatively using
    #   CLASS_OR_VALUE itself if it responds to #parse
    # @raise [ArgumentError] If a type that handles CLASS_OR_VALUE hasn’t been
    #   registered
    def [](class_or_value)
      type = @types[class_or_value] and return type
      pair = @types.find{ |c, t| class_or_value.is_a? c } and return pair.last
      class_or_value.respond_to? :parse and return class_or_value
      raise ArgumentError, 'unknown type: %p' % [class_or_value]
    end
  end
end
