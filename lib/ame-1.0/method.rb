# -*- coding: utf-8 -*-

# A method in its defined state.
# @api developer
class Ame::Method
  class << self
    # @param [String] name
    # @return [Symbol] The Ruby version of NAME, possibly the name of the
    #   method given on the command-line, replacing any ‘-’ with ‘_’.
    def ruby_name(name)
      name.gsub('-', '_').to_sym
    end

    # @param [Symbol] ruby_name
    # @return [String] The command-line version of RUBY_NAME, replacing any ‘_’
    #   with ‘-’
    def name(ruby_name)
      ruby_name.to_s.gsub('_', '-')
    end
  end

  def initialize(ruby_name, klass, description, options, arguments)
    @ruby_name, @class, @description, @options, @arguments =
      ruby_name, klass, description, options, arguments
  end

  # Process ARGUMENTS as a set of {Options} and {Arguments}, then {#call} the
  # receiver’s method on INSTANCE with them.
  # @api internal
  # @param [Class] instance
  # @param [Array<String>] arguments
  # @raise (see Options#process)
  # @raise (see Arguments#process)
  # @return [self]
  def process(instance, arguments)
    options, remainder = @options.process(arguments)
    call(instance, @arguments.process(options, remainder), options)
  end

  # Call the receiver’s method on INSTANCE with ARGUMENTS and OPTIONS,
  # retrieving any default values for them if they’re nil.
  # @api internal
  # @param [Class] instance
  # @param [Array<Object>, nil] arguments
  # @param [Hash<String, Object>] options
  # @raise (see Options#process)
  # @raise (see Arguments#process)
  # @return [self]
  def call(instance, arguments = nil, options = nil)
    options, _ = @options.process([]) unless options
    arguments ||= @arguments.process(options, [])
    instance.send @ruby_name, *(arguments + (options.empty? ? [] : [options]))
    self
  end

  # @return [String] The description of the receiver
  attr_reader :description

  # @return [Options] The options of the receiver
  attr_reader :options

  # @return [Arguments] The arguments of the receiver
  attr_reader :arguments

  # @return [String] The command-line name of the receiver
  def name
    @name ||= self.class.name(@ruby_name)
  end

  # @return [String] The full command-line name of the receiver, including the
  #   class that this method belongs to’s {Class.fullname}
  def qualified_name
    [@class.fullname, name].reject(&:empty?).join(' ')
  end
end
