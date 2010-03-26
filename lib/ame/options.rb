# -*- coding: utf-8 -*-

class Ame::Options
  def initialize
    @options = {}
  end

  def option(name, description, options = {}, &block)
    option = Ame::Option.new(name, description, options, &block)
    self[option.name] = option
    options.fetch(:aliases, []).each do |a|
      self[a] = option
    end
    self
  end

  def process(arguments)
    process!(defaults, arguments.dup)
  end

private

  def defaults
    {}.tap{ |results|
      @options.each_value do |option|
        results[option.name] = option.default
      end
    }
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
        match = $1
        arg = $2
        raise Ame::UnrecognizedOption,
          'Unrecognized option: %s' %
            match unless option = @options[match.sub(/^-+/, "")]
        results[option.name] = option.process(results,
                                              argument(arg, option, arguments))
      else
        remainder << first
        break if ENV.include? 'POSIXLY_CORRECT'
      end
    end
    [results, remainder.concat(arguments)]
  end

  def []=(name, option)
    raise ArgumentError, "Option #{name} already defined" if @options.include? name
    @options[name] = option
  end

  def argument(argument, option, arguments)
    case
    when argument then argument
    when option.optional? then nil
    else arguments.shift
    end
  end
end
