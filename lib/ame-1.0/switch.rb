# -*- coding: utf-8 -*-

class Ame::Switch < Ame::Flag
  def initialize(short, long, argument, default, argument_default, description, &validate)
    @argument = argument.upcase
    @type = Ame::Types[[argument_default, default, String].reject(&:nil?).first]
    @argument_default = @type.respond_to?(:default) ? @type.default : argument_default
    super short, long, default, description, &validate
  end

  attr_reader :argument

  private

  def parse(arguments, explicit)
    explicit ? @type.parse(explicit) : @argument_default
  end
end
