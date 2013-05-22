# -*- coding: utf-8 -*-

class Ame::Flag
  def initialize(short, long, default, description, &validate)
    @short, @long, @default, @description, @validate =
      short.strip, long.strip, default, description, validate || proc{ |_, _, a| a }
    raise ArgumentError if short.empty? and long.empty?
    raise ArgumentError if description.empty?
  end

  def process(options, arguments, name, explicit)
    @validate.call(options, [], explicit ? Ame::Types[TrueClass].parse(explicit) : !default)
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end

  def process_combined(options, arguments, name, remainder)
    [process(options, arguments, name, nil), remainder]
  end

  def to_s
    (name.to_s.length > 1 ? '--%s' : '-%s') % name
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

  def argument_name
    ''
  end

  def short
    @short.empty? ? nil : @short
  end

  def long
    @long.empty? ? nil : @long
  end

  attr_reader :default

  attr_reader :description
end
