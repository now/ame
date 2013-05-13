# -*- coding: utf-8 -*-

class Ame::Root < Ame::Class
  class << self
    def basename
      ''
    end

    def process(method = File.basename($0), arguments = ARGV)
      new.process(method, arguments)
    rescue => e
      help.for_error method, e
    end

    def help(help = nil)
      return @help = help if help
      @help ||= Ame::Help::Console.new
    end

    def version(version = nil)
      return @version = version if version
      raise 'version not set, call %s.version VERSION' % self unless @version
      @version
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

  class << self
    private

    def method_added(name)
      m = method
      option :version, 'Display version information', :ignore => true do
        help.version m, self.version
        throw Ame::AbortAllProcessing
      end unless method.options.include? :version
      super
    end
  end
end
