# -*- coding: utf-8 -*-

class Ame::Multioption < Ame::Option
  def initialize(short, long, argument, type, description, &validate)
    super short, long, argument, nil, description, &validate
    @type = Ame::Types[type]
    @ignored = true
  end

  def process(options, arguments, name, explicit)
    @ignored = false
    (options[self.name] ||= []) << super
  end

  def ignored?
    @ignored
  end
end
