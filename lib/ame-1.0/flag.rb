# -*- coding: utf-8 -*-

class Ame::Flag < Ame::Option
  def initialize(short, long, default, description, &validate)
    short = short.strip
    long = long.strip
    options = { :default => !!default }
    options[:ignore] = true if default.nil?
    options[:alias] = short unless long.empty? or short.empty?
    super long.empty? ? short : long, description, options, &validate
  end

  def process(options, arguments, name, explicit)
    @validate.call(options, [], explicit ? Ame::Types[Boolean].parse(explicit) : !default)
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end

  def process_combined(options, arguments, name, remainder)
    [process(options, arguments, name, nil), remainder]
  end

  def names
    [long, short].select{ |e| e }.each do |name|
      yield name
    end
    self
  end

  def optional?
    true
  end
end
