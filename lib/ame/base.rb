# -*- coding: utf-8 -*-

module Ame::Base
  autoload :ClassMethods, 'ame/base/classmethods'

  def process(name, arguments = [])
    Ame::Classes.method(name, self).process arguments
    self
  end

  def call(name, arguments = nil, options = nil)
    Ame::Classes.method(name, self).call arguments, options
    self
  end
end
