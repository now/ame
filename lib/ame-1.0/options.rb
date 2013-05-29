# -*- coding: utf-8 -*-

# The options to a method in its {Method defined state}.  Does the processing
# of options to the method and also enumerates {#each} of the options to the
# method for, for example, help output.
# @api developer
class Ame::Options
  include Enumerable

  def initialize(options, ordered, options_must_precede_arguments)
    @options, @ordered, @options_must_precede_arguments =
      options, ordered, options_must_precede_arguments
  end

  # @api internal
  # @param [Array<String>] arguments
  # @raise [UnrecognizedOption] If an unrecognized option has been given
  # @raise (see Flag#process)
  # @return [[Hash<String,Object>, Array<String>]] The {Flag#process}ed options
  #   as a Hash mapping the {Flag#name} to the parsed value or the option’s
  #   default after filtering out any {Flag#ignored?} options and the remaining
  #   non-option arguments
  def process(arguments)
    arguments = arguments.dup
    results = @ordered.reduce({}){ |d, o| d[o.name] = o.default; d }
    remainder = []
    until arguments.empty?
      case first = arguments.shift
      when '--'
        break
      when /\A-([^=-]{2,})\z/
        combined = $1
        until combined.empty?
          option = self['-' + combined[0].chr]
          results[option.name], combined = option.process_combined(results, arguments, $1, combined[1..-1])
        end
      when /\A(--[^=]+|-[^-])(?:=(.*))?\z/
        option = self[$1]
        results[option.name] = option.process(results, arguments, $1, $2)
      else
        remainder << first
        break if @options_must_precede_arguments
      end
    end
    [results.reject{ |n, _| self[n].ignored? }, remainder.concat(arguments)]
  end

  # @overload
  #   Enumerates the options.
  #
  #   @yieldparam [Option] option
  # @overload
  #   @return [Enumerator<Option>] An Enumerator over the options
  def each
    return enum_for(__method__) unless block_given?
    @ordered.each do |option|
      yield option
    end
    self
  end

  private

  def [](name)
    @options[name.sub(/\A-+/, '')] or
      raise Ame::UnrecognizedOption, 'unrecognized option: %s' % name
  end
end
