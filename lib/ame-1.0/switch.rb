# -*- coding: utf-8 -*-

class Ame::Switch < Ame::Option
  def initialize(short, long, argument, default, argument_default, description, &validate)
    @argument_default = argument_default
    short = short.strip
    long = long.strip
    options = { :default => default }
    options[:alias] = short unless long.empty? or short.empty?
    super long.empty? ? short : long, description, options, &validate
  end

  def process(options, arguments, name, explicit)
    @validate.call(options, [], explicit ? @type.parse(explicit) : @argument_default)
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [name, e]
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
