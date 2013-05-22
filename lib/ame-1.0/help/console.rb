# -*- coding: utf-8 -*-

class Ame::Help::Console
  def initialize(output = $stdout, error = $stderr, exit_on_error = true)
    @output, @error, @exit_on_error = output, error, exit_on_error
  end

  def dispatch(method, klass)
    output method_s(method).tap{ |result|
      append_group result, 'Methods', klass.methods.sort_by{ |m| method_name(m) } do |e|
        method_name(e)
      end
    }
  end

  def method(method)
    output method_s(method)
  end

  def version(method, version)
    output '%s %s' % [method.name, version]
  end

  def error(method, error)
    errput '%s: %s' % [method, error]
    exit 1 if @exit_on_error
    raise error
  end

private

  def output(string)
    @output.puts string
  end

  def errput(string)
    @error.puts string
  end

  def method_s(method)
    ['Usage:'].tap{ |result|
      append result, ' ', method.qualified_name
      append result, ' ', method.options.count > 0 ? '[OPTIONS]...' : ''
      append result, ' ', method.arguments.map{ |a|
        if a.optional? and a.arity < 0 then '[%s]...'
        elsif a.optional? then '[%s]'
        elsif a.arity < 0 then '%s...'
        else '%s'
        end % a
      }.join(' ')
      result << "\n"
      append result, '  ', method.description
      append_group result, 'Arguments', method.arguments do |argument|
        r = argument.to_s
        r << '=%s' % argument.default if argument.default
        r = '[%s]' % r if argument.optional?
        r << '...' if argument.arity < 0
        r
      end
      append_group result, 'Options', method.options.sort_by{ |o| (o.short or o.long).to_s } do |option|
        case option
        when Ame::Option
          if option.short and option.long
            '-%s, --%s=%s' % [option.short, option.long, option.argument_name.upcase]
          elsif option.short
            '-%s%s' % [option.short, option.argument_name.upcase]
          else
            '    --%s=%s' % [option.long, option.argument_name.upcase]
          end
        when Ame::Switch
          if option.short and option.long
            '-%s, --%s[=%s]' % [option.short, option.long, option.argument_name.upcase]
          elsif option.short
            '-%s[=%s]' % [option.short, option.argument_name.upcase]
          else
            '    --%s[=%s]' % [option.long, option.argument_name.upcase]
          end
        else
          if option.short and option.long
            '-%s, --%s' % [option.short, option.long]
          elsif option.short
            '-%s' % option.short
          else
            '    --%s' % option.long
          end
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

  def method_name(method)
    method.name.to_s
  end
end
