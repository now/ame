# -*- coding: utf-8 -*-

module Ame::Help::Console
  def self.method(method, program = "")
    args = arguments(method.arguments)
    opts = options(method.options)
    "Usage: ".tap{ |result|
      result << program << ' ' if program.length > 0
      result << method.name
      result << ' ' << args if args.length > 0
      result << "\n  " << method.description
      result << "\n\nOptions:\n" << opts if opts.length > 0
    }
  end

  # Make rest private and turn this into a class, taking program in constructor

  def self.arguments(arguments)
    arguments.map{ |a| argument(a) }.tap{ |as|
      as << splat(arguments.splat) if arguments.splat
    }.join(' ')
  end

  def self.argument(argument)
    (argument.optional? ? '[%s]' : '%s') % argument
  end

  def self.splat(splat)
    '%s...' % argument(splat)
  end

  def self.options(options)
    longest = options.map{ |o| option(o).length }.max
    options.sort_by{ |o| o.short || o.long }.
      map{ |o| '  %-*s  %s' % [longest, option(o), o.description] }.join("\n")
  end

  def self.option(option)
    if not option.long
      '-%s' % option.short
    elsif option.short and option.argument_name.empty?
      '-%s, --%s' % [option.short, option.long]
    elsif option.short
      '-%s, --%s=%s' % [option.short, option.long, option.argument_name]
    elsif option.argument_name.empty?
      '    --%s' % option.long
    else
      '    --%s=%s' % [option.long, option.argument_name]
    end
  end
end
