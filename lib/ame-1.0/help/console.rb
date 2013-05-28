# -*- coding: utf-8 -*-

# Outputs help requests to a pair of IO objects, defaulting to `$stdout` and
# `$stderr`.  An instance of this class is used by default for outputting help
# requests from {Root}, but can be overridden by invoking {Root.help} with
# another object (such as an instance of this class that’s been constructed
# with different parameters).
# @api developer/user
class Ame::Help::Console
  # Sets up help requests to be made to OUTPUT ({#dispatch}, {#method}, and
  # {#version}) and ERROR ({#error}), as well as specifying whether to
  # EXIT_ON_ERROR or not, see {#error}.
  # @param [#puts] output
  # @param [#puts] error
  # @param [Boolean] exit_on_error
  def initialize(output = $stdout, error = $stderr, exit_on_error = true)
    @output, @error, @exit_on_error = output, error, exit_on_error
  end

  # Outputs a help request for a {Class.dispatch} METHOD to KLASS, displaying
  # all options and arguments to the method and listing the possible dispatch
  # methods.
  # @param [Method] method
  # @param [Class] klass
  # @return [self]
  def dispatch(method, klass)
    output(method_s(method).tap{ |result|
      append_group result, 'Methods', klass.methods.sort_by{ |m| m.name } do |m|
        m.name
      end
    })
  end

  # Outputs a help request for METHOD, displaying all its options and
  # arguments.
  # @param [Method] method
  # @return [self]
  def method(method)
    output(method_s(method))
  end

  # Outputs VERSION information for METHOD.
  # @param [Method] method
  # @param [String] version
  # @return [self]
  def version(method, version)
    output('%s %s' % [method.name, version])
  end

  # Outputs ERROR that occurred while processing METHOD.
  # @raise [SystemExit] If exit_on_error was given as true to the receiver’s
  #   constructor
  # @raise [error] If exit_on_error wasn’t given as true to the receiver’s
  #   constructor
  def error(method, error)
    errput '%s: %s' % [method, error]
    exit 1 if @exit_on_error
    raise error
  end

  private

  def output(string)
    @output.puts string
    self
  end

  def errput(string)
    @error.puts string
    self
  end

  def method_s(method)
    ['Usage:'].tap{ |result|
      append result, ' ', method.qualified_name
      append result, ' ', method.options.count > 0 ? '[OPTIONS]...' : ''
      append result, ' ', method.arguments.map{ |a|
        case a
        when Ame::Splat then '[%s]...'
        when Ame::Splus then '%s...'
        when Ame::Optional then '[%s]'
        else '%s'
        end % a
      }.join(' ')
      result << "\n"
      append result, '  ', method.description
      append_group result, 'Arguments', method.arguments do |argument|
        case argument
        when Ame::Splat then '[%s]...' % argument
        when Ame::Splus then '%s...' % argument
        when Ame::Optional then '[%s=%s]' % [argument, argument.default]
        else argument.to_s
        end
      end
      append_group result, 'Options', method.options.select{ |o| o.description }.sort_by{ |o| (o.short or o.long).to_s } do |o|
        case o
        when Ame::Multioption then '%s*' % option(o)
        when Ame::Option then option(o)
        when Ame::Switch then '%s[=%s]' % [flag(o), o.argument]
        else flag(o)
        end
      end
    }.join('')
  end

  def append(result, prefix, string)
    result << prefix << string unless string.empty?
  end

  def append_group(result, heading, objects)
    strings = objects.map{ |o| [o, yield(o)] }
    longest = strings.map{ |_, s| s.length }.max
    append result, "\n\n%s:\n" % heading,
      strings.map{ |o, s| '  %-*s  %s' % [longest, s, o.description] }.join("\n")
  end

  def flag(option)
    if option.short and option.long
      '-%s, --%s' % [option.short, option.long]
    elsif option.short
      '-%s' % option.short
    else
      '    --%s' % option.long
    end
  end

  def option(option)
    '%s%s%s' % [flag(option), option.long ? '=' : '', option.argument]
  end
end
