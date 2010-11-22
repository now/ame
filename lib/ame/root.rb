# -*- coding: utf-8 -*-

class Ame::Root < Ame::Class
  class << self
    def basename
      ''
    end

    def process(method = File.basename($0), arguments = ARGV)
      new.process(method, arguments)
    end

    def method_added(name)
      m = method
      option 'version', 'Display version information' do
        help.version self, m
        throw Ame::AbortAllProcessing
      end unless method.options.include? 'version'
      super
    end
  end

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
