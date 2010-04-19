# -*- coding: utf-8 -*-

module Ame::Help::Console
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
      map{ |o| '%-*s  %s' % [longest, option(o), o.description] }.join("\n")
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
