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

private

  def []=(name, option)
    raise ArgumentError,
      'option already defined: %s' % name if @options.include? name
    @options[name] = option
  end

  def defaults
    @ordered.inject({}){ |d, o| d[o.name] = o.default; d }
  end

  def process!(results, arguments)
    remainder = []
    until arguments.empty?
      case first = arguments.shift
      when '--'
        break
      when /^-([^=-]{2,})$/
        arguments.unshift *$1.split("").map{ |s| '-' + s }
      when /^(--[^=]+|-[^-])(?:=(.*))?$/
        process1 results, arguments, $1, $2
      else
        remainder << first
        break if @options_must_precede_arguments
      end
    end
    [results, remainder.concat(arguments)]
  end

  def process1(results, arguments, match, arg)
    raise Ame::UnrecognizedOption,
      'unrecognized option: %s' % match unless
        option = @options[match.sub(/^-+/, "")]
    results[option.name] = option.process(results, [], argument(arg, option, arguments))
  end

  def argument(argument, option, arguments)
    case
    when argument then argument
    when option.optional? then (!option.default).to_s
    else arguments.shift
    end
  end
end
