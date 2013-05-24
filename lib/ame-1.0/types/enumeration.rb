# -*- coding: utf-8 -*-

class Ame::Types::Enumeration
  class << self
    alias [] new
  end

  def initialize(*names)
    @names = names
  end

  def parse(value)
    @names.include?(s = value.to_sym) ? s : raise(Ame::MalformedArgument, 'not a valid enumeration value: %s' % value)
  end
end
