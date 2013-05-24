# -*- coding: utf-8 -*-

class Ame::Help::Console
  def initialize(output = $stdout, error = $stderr, exit_on_error = true)
    @output, @error, @exit_on_error = output, error, exit_on_error
  end

  def dispatch(method, klass)
    output method_s(method).tap{ |result|
      append_group result, 'Methods', klass.methods.sort_by{ |m| m.name } do |m|
        m.name
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
      append_group result, 'Options', method.options.select{ |o| o.description }.sort_by{ |o| (o.short or o.long).to_s } do |option|
        case option
        when Ame::Multioption
          if option.short and option.long
            '-%s, --%s=%s*' % [option.short, option.long, option.argument]
          elsif option.short
            '-%s%s*' % [option.short, option.argument]
          else
            '    --%s=%s*' % [option.long, option.argument]
          end
        when Ame::Option
          if option.short and option.long
            '-%s, --%s=%s' % [option.short, option.long, option.argument]
          elsif option.short
            '-%s%s' % [option.short, option.argument]
          else
            '    --%s=%s' % [option.long, option.argument]
          end
        when Ame::Switch
          if option.short and option.long
            '-%s, --%s[=%s]' % [option.short, option.long, option.argument]
          elsif option.short
            '-%s[=%s]' % [option.short, option.argument]
          else
            '    --%s[=%s]' % [option.long, option.argument]
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
end
