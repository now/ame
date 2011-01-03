# -*- coding: utf-8 -*-

class Ame::Options
  include Enumerable

  def initialize
    @options = {}
    @ordered = []
    @options_must_precede_arguments = ENV.include? 'POSIXLY_CORRECT'
  end

  def option(name, description, options = {}, &block)
    option = Ame::Option.new(name, description, options, &block)
    self[option.name] = option
    option.aliases.each do |a|
      self[a] = option
    end
    @ordered << option
    self
  end

  def options_must_precede_arguments
    @options_must_precede_arguments = true
    self
  end

  def process(arguments)
    process!(defaults, arguments.dup)
  end

  def each
    @ordered.each do |option|
      yield option
    end
    self
  end

  def include?(name)
    @options.include? name
  end

private

  def []=(name, option)
    raise ArgumentError,
      'option already defined: %s' % name if include? name
    @options[name] = option
  end

  def [](name)
    @options[name.sub(/^-+/, "")] or
      raise Ame::UnrecognizedOption, 'unrecognized option: %s' % name
  end

  def defaults
    @ordered.reduce({}){ |d, o| d[o.name] = o.default; d }
  end

  def process!(results, arguments)
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
