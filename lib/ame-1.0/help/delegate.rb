# -*- coding: utf-8 -*-

class Ame::Help::Delegate
  def initialize(help)
    @help = help
  end

  def dispatch(method, klass)
    @help.dispatch method, klass
    self
  end

  def method(method)
    @help.method method
    self
  end
end
