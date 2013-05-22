# -*- coding: utf-8 -*-

class Ame::Flag
  def initialize(short, long, default, description, &validate)
    s, l = short.strip, long.strip
    @short, @long, @default, @description, @validate =
      s.empty? ? nil : s, l.empty? ? nil : l, default, description, validate || proc{ |_, a| a }
    raise ArgumentError if @short.nil? and @long.nil?
    raise ArgumentError if @short and @short.length > 1
    raise ArgumentError if description.empty?
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
    names.first.to_sym
  end

  def names
    [long, short].reject{ |e| e.nil? }
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
