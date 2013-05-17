# -*- coding: utf-8 -*-

# The defined options.
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
      when /\A-([^=-]{2,})\z/
        process_combined results, arguments, $1
      when /\A(--[^=]+|-[^-])(?:=(.*))?\z/
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
    @options[name.to_s.sub(/\A-+/, '')] or
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

  def process1(results, arguments, option, explicit)
    results[option.name] = option.process(results, arguments, explicit)
  end
end
