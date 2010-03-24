# -*- coding: utf-8 -*-

class Ame::Option < Ame::Argument
  def initialize(name, description, options = {}, &validate)
    options[:type] ||= :boolean
    options[:optional] = options[:type] == :boolean
    super
  end

  def to_s
    name
  end
end
