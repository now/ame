# -*- coding: utf-8 -*-

class Ame::Options
  include Enumerable

  def initialize(options, ordered, options_must_precede_arguments)
    @options, @ordered, @options_must_precede_arguments =
      options, ordered, options_must_precede_arguments
  end

  def process(arguments)
    arguments = arguments.dup
    results = @ordered.reduce({}){ |d, o| d[o.name] = o.default; d }
    remainder = []
    until arguments.empty?
      case first = arguments.shift
      when '--'
        break
      when /^-([^=-]{2,})$/
        process_combined results, arguments, $1
      when /^(--[^=]+|-[^-])(?:=(.*))?$/
        process1 results, arguments, self[$1], $2
      else
        remainder << first
        break if @options_must_precede_arguments
      end
    end
    [results.reject{ |n, _| self[n].ignored? }, remainder.concat(arguments)]
  end

  def each
    @ordered.each do |option|
      yield option
    end
    self
  end

  private

  def [](name)
    @options[name.to_s.sub(/^-+/, "")] or
      raise Ame::UnrecognizedOption, 'unrecognized option: %s' % name
  end

  def process_combined(results, arguments, combined)
    combined.each_char.with_index do |c, i|
      option = self['-' + c]
      if option.optional?
        process1 results, [], option, nil
      elsif i == combined.length - 1
        process1 results, arguments, option, nil
      else
        process1 results, [], option, combined[i+1..-1]
        break
      end
    end
  end

  def process1(results, arguments, option, arg)
    results[option.name] = option.process(results, [], argument(arguments, option, arg))
  end

  def argument(arguments, option, argument)
    case
    when argument then argument
    when option.optional? then (!option.default).to_s
    else arguments.shift
    end
  end
end
