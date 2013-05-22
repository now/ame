# -*- coding: utf-8 -*-

class Ame::Flag
  def initialize(short, long, default, description, &validate)
    @short, @long, @default, @description, @validate =
      (s = short.strip).empty? ? nil : s, (l = long.strip).empty? ? nil : l,
      default, description, validate || proc{ |_, a| a }
    raise ArgumentError, 'both short and long can’t be empty' if
      @short.nil? and @long.nil?
    raise ArgumentError, 'short can’t be longer than 1: %s' % @short if
      @short and @short.length > 1
  end

  def process(options, arguments, name, explicit)
    @validate.call(options, parse(arguments, explicit))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [name, e]
  end

  def process_combined(options, arguments, name, remainder)
    [process(options, arguments, name, nil), remainder]
  end

  def name
    @name ||= names.first
  end

  def names
    @names ||= [long, short].reject{ |e| e.nil? }
  end

  def ignored?
    default.nil?
  end

  attr_reader :short

  attr_reader :long

  attr_reader :default

  attr_reader :description

  private

  def parse(arguments, explicit)
    explicit ? Ame::Types[TrueClass].parse(explicit) : !default
  end
end
