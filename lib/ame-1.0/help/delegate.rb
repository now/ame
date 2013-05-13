# -*- coding: utf-8 -*-

class Ame::Help::Delegate
  def initialize(help)
    @help = help
  end

  def for_dispatch(method, klass)
    @help.for_dispatch method, klass
    self
  end

  def for_method(method)
    @help.for_method method
    self
  end
end
