# -*- coding: utf-8 -*-

class Ame::Switch < Ame::Flag
  def initialize(short, long, argument, default, argument_default, description, &validate)
    @argument, @argument_default = argument, argument_default
    @type = Ame::Types[[default, argument_default, String].reject(&:nil?).first]
    super short, long, default, description, &validate
  end

  def process(options, arguments, name, explicit)
    @validate.call(options, [], explicit ? @type.parse(explicit) : @argument_default)
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [name, e]
  end

  def argument_name
    @argument
  end
end
