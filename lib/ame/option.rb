# -*- coding: utf-8 -*-

class Ame; end

class Ame::Option < Ame::Argument
  def initialize(name, description, options = {}, &validate)
    options[:type] ||= :boolean
    options[:optional] = options[:type] == :boolean
    @type = options[:type]
    @aliases = options[:aliases] || []
    super
  end

  def to_s
    name
  end
end
