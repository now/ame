# -*- coding: utf-8 -*-

class Ame::Help::Console
  def initialize(io = STDOUT)
    @io = io
  end

  def for_dispatch(klass, method, subclass)
    @io.puts for_method_s(klass, method).tap{ |result|
      append_group result, 'Methods', methods(subclass.methods)
    }
  end

  def for_method(klass, method)
    @io.puts for_method_s(klass, method)
  end

private

  def for_method_s(klass, method)
    'Usage: '.tap{ |result|
      result << klass.namespace << ' ' << method.name.to_s
      append result, ' ', options_usage(method.options)
      append result, ' ', arguments_usage(method.arguments)
      result << "\n  " << method.description
      append_group result, 'Arguments', arguments(method.arguments)
      append_group result, 'Options', options(method.options)
    }
  end

  def append(result, prefix, string)
    result << prefix << string unless string.empty?
  end

  def append_group(result, heading, listing)
    append result, "\n\n%s:\n" % heading, listing
  end

  def options_usage(options)
    options.count > 0 ? '[OPTIONS]...' : ""
  end

  def arguments_usage(arguments)
    arguments.map{ |a| argument_usage(a) }.tap{ |as|
      as << splat_usage(arguments.splat) if arguments.splat
    }.join(' ')
  end

  def argument_usage(argument)
    (argument.optional? ? '[%s]' : '%s') % argument
  end

  def splat_usage(splat)
    '%s...' % argument_usage(splat)
  end

  def arguments(arguments)
    longest = arguments.map{ |a| argument(a).length }.tap{ |as|
      as << splat(arguments.splat).length if arguments.splat
    }.max
    arguments.
      map{ |a| '  %-*s  %s' % [longest, argument(a), a.description] }.
      tap{ |as| as <<
        '  %-*s  %s' %
          [longest, splat(arguments.splat), arguments.splat.description] if
            arguments.splat }.
      join("\n")
  end

  def argument(argument)
    if argument.optional? and not argument.default.nil?
      '[%s=%s]' % [argument, argument.default]
    elsif argument.optional?
      '[%s]' % argument
    else
      argument.to_s
    end
  end

  def splat(splat)
    '%s...' % argument(splat)
  end

  def options(options)
    longest = options.map{ |o| option(o).length }.max
    options.sort_by{ |o| o.short || o.long }.
      map{ |o| '  %-*s  %s' % [longest, option(o), o.description] }.join("\n")
  end

  def option(option)
    if not option.long and option.argument_name.empty?
      '-%s' % option.short
    elsif not option.long
      '-%s=%s' % [option.short, option.argument_name.upcase]
    elsif option.short and option.argument_name.empty?
      '-%s, --%s' % [option.short, option.long]
    elsif option.short
      '-%s, --%s=%s' % [option.short, option.long, option.argument_name.upcase]
    elsif option.argument_name.empty?
      '    --%s' % option.long
    else
      '    --%s=%s' % [option.long, option.argument_name.upcase]
    end
  end

  def methods(methods)
    longest = methods.map{ |a| method(a).length }.max
    methods.sort_by{ |m| method(m) }.
      map{ |m| '  %-*s  %s' % [longest, method(m), m.description] }.join("\n")
  end

  def method(method)
    method.name.to_s
  end
end
