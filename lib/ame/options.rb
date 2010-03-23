# -*- coding: utf-8 -*-

require 'ostruct'

class Ame::Options
  def initialize
    @options = {}
  end

  def option(name, description, options = {}, &block)
    # TODO: Deal with --boolean and --no-boolean
    # TODO: Deal with --with-* and --without-*
    option = Ame::Option.new(name, description, options, &block)
    @options[name] = option
    options.fetch(:aliases, []).each do |a|
      raise ArgumentError, "Option #{a} already defined" if @options.key? a
      @options[a] = option
    end
  end

  def process(arguments)
    stack = arguments.dup
    results = OpenStruct.new
    @options.each do |option|
      results[option.name] = option.default
    end
    remainder = []
    until stack.empty?
      case top = stack.shift
      when /^-([a-z]+)$/i
        stack.unshift *$1.split(//).map{ |s| '-' + s }
        next
      when '--'
        break
      when /^(--[a-z]+[-a-z]*|-[a-z])(?:=(.*))$/i
        name = $1.sub(/^-+/, '')
        raise UnrecognizedOption, "Unrecognized option: #{$1}" unless option = @options[name]
        stack.unshift 'yes' if not $2 and option.optional?
        stack.unshift $2 if $2
        results[option.name] = option.process(results, stack)
      else
        remainder << top
        break if ENV['POSIXLY_CORRECT']
      end
    end
    [results, remainder.concat(stack)]
  end
end
