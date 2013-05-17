# -*- coding: utf-8 -*-

# An option to an Ame {Method}.
class Ame::Option < Ame::Argument
  # Defines option NAME with DESCRIPTION of TYPE that might take an ARGUMENT,
  # with an optional DEFAULT, and its ALIAS and/or ALIASES, using an optional
  # block for any validation or further processing, where OPTIONS are the
  # options processed so far and their values, PROCESSED are the values of the
  # arguments processed so far, and ARGUMENT is the value of the argument
  # itself.  If specified, IGNORE it when passing options to the method.
  # @param (see Argument#initialize)
  # @param [Hash] options
  # @option options [Module] :type (nil) The type of the option
  # @option options [Object] :default (false) The default to use if the option
  #   isn’t specified; the default will be true if TYPE is FalseClass
  # @option options [#to_s] :argument (NAME) The name of the argument to the
  #   option
  # @option options [Symbol] :alias An alias for the option
  # @option options [Array<Symbol>] :aliases An Array of aliases for the option
  # @option options [Boolean] :ignore If true, the option won’t be passed on to
  #   the method
  # @raise [ArgumentError] If OPTIONAL and TYPE isn’t Boolean
  # @raise [ArgumentError] If DEFAULT is a Boolean and the ARGUMENT option has
  #   been given
  # @raise [ArgumentError] If DEFAULT isn’t of TYPE
  # @yield (see Argument#initialize)
  # @yieldparam (see Argument#initialize)
  def initialize(name, description, options = {}, &validate)
    is_boolean_type = [TrueClass, FalseClass].include? options[:type]
    options[:default] = false unless options.include? :default or options.include? :type
    if is_boolean_type and not options.include? :default
      options[:default] = options[:type] == FalseClass
    end
    is_boolean = [true, false].include? options[:default]
    raise ArgumentError,
      'optional arguments to options are only allowed for booleans' if
        options[:optional] and not(is_boolean_type or is_boolean)
    options[:optional] = is_boolean
    raise ArgumentError,
      'boolean options cannot have argument descriptions' if
        is_boolean and options[:argument]
    @argument_name = is_boolean ? "" : (options[:argument] || name).to_s
    @aliases = Array(options[:alias]) + Array(options[:aliases])
    @ignored = options[:ignore]
    super
  end

  def process(options, arguments, explicit)
    arg = argument(arguments, explicit)
    raise Ame::MissingArgument, 'missing argument: %s' % self if required? and arg.nil?
    @validate.call(options, [], arg.nil? ? default : @type.parse(arg))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end

  def process_combined(options, arguments, remainder)
    optional? || remainder.empty? ?
      [process(options, arguments, nil), remainder] :
      [process(options, arguments, remainder), ""]
  end

  def to_s
    (name.to_s.length > 1 ? '--%s' : '-%s') % name
  end

  attr_reader :argument_name, :aliases

  def short
    [name, *aliases].find{ |a| a.to_s.length == 1 }
  end

  def long
    [name, *aliases].find{ |a| a.to_s.length > 1 }
  end

  def ignored?
    @ignored
  end

private

  def set_default(value, type)
    saved_optional, @optional = @optional, true
    super
  ensure
    @optional = saved_optional
  end

  def argument(arguments, explicit)
    case
    when explicit then explicit
    when optional? then (!default).to_s
    else arguments.shift
    end
  end
end
