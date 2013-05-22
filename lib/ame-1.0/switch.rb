# -*- coding: utf-8 -*-

class Ame::Switch < Ame::Flag
  def initialize(short, long, argument, default, argument_default, description, &validate)
    @argument, @argument_default = argument, argument_default
    @type = Ame::Types[[default, argument_default, String].reject(&:nil?).first]
    super short, long, default, description, &validate
  end

  def argument_name
    @argument
  end

  private

  def argument(arguments, explicit)
    explicit ? @type.parse(explicit) : @argument_default
  end
end
