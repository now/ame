# -*- coding: utf-8 -*-

class Ame::Toggle < Ame::Option
  def initialize(short, long, default, description, &validate)
    short = short.strip
    long = long.strip
    options = { :default => default }
    options[:alias] = short unless long.empty? or short.empty?
    super long.empty? ? short : long, description, options, &validate
  end

  def process(options, arguments, name, explicit)
    @validate.call(options, [],
                   explicit ?
                     (name =~ /\A--no-/) ^ @type.parse(explicit) :
                     (name =~ /\A--no-/ ? default : !default))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [name, e]
  end

  def names
    [long, short, long ? 'no-%s' % long : nil].select{ |e| e }.each do |name|
      yield name
    end
    self
  end
end
