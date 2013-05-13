# -*- coding: utf-8 -*-

class Ame::Help::Console
  def initialize(output = $stdout, error = $stderr, exit_on_error = true)
    @output, @error, @exit_on_error = output, error, exit_on_error
  end

  def for_dispatch(method, subclass)
    output for_method_s(method).tap{ |result|
      append_group result, 'Methods', :method, subclass.methods.sort_by{ |m| method(m) }
    }
  end

  def for_method(method)
    output for_method_s(method)
  end

  def version(method, version)
    output '%s %s' % [method.name, version]
  end

  def for_error(method, error)
    error '%s: %s' % [method, error]
    exit 1 if @exit_on_error
    raise error
  end

private

  def output(string)
    @output.puts string
  end

  def error(string)
    @error.puts string
  end

  def for_method_s(method)
    ['Usage:'].tap{ |result|
      append result, ' ', method.qualified_name
      append result, ' ', options_usage(method.options)
      append result, ' ', arguments_usage(method.arguments)
      result << "\n"
      append result, '  ', method.description
      append_group result, 'Arguments', :argument, method.arguments
      append_group result, 'Options', :option, method.options.sort_by{ |o| (o.short or o.long).to_s }
    }.join('')
  end

  def append(result, prefix, string)
    result << prefix << string unless string.empty?
  end

  def append_group(result, heading, display, objects)
    longest = objects.map{ |o| send(display, o).length }.max
    append result, "\n\n%s:\n" % heading,
      objects.map{ |o| '  %-*s  %s' % [longest, send(display, o), o.description] }.join("\n")
  end

  def options_usage(options)
    options.count > 0 ? '[OPTIONS]...' : ''
  end

  def arguments_usage(arguments)
    arguments.map{ |a|
      if a.optional? and a.arity < 0 then '[%s]...'
      elsif a.optional? then '[%s]'
      elsif a.arity < 0 then '%s...'
      else '%s'
      end % a
    }.join(' ')
  end

  def argument(argument)
    result = argument.to_s
    result << '=%s' % argument.default if argument.default
    result = '[%s]' % result if argument.optional?
    result << '...' if argument.arity < 0
    result
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

  def method(method)
    method.name.to_s
  end
end