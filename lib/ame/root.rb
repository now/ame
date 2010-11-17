# -*- coding: utf-8 -*-

class Ame::Root < Ame::Class
  def process(name, arguments = [])
    catch Ame::AbortAllProcessing do
      super
    end
    self
  end

  def call(name, arguments = nil, options = nil)
    catch Ame::AbortAllProcessing do
      super
    end
    self
  end
end
