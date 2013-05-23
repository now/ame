# -*- coding: utf-8 -*-

class Ame::Optional < Ame::Argument
  def initialize(name, default, description, &validate)
    @default = default
    super
  end

  # @return [Object, nil] The default value of the receiver
  attr_reader :default

  private

  def parse(arguments)
    arguments.empty? ? default : super
  end
end
