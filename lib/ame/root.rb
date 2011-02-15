# -*- coding: utf-8 -*-

class Ame::Root < Ame::Class
  class << self
    def basename
      ''
    end

    def process(method = File.basename($0), arguments = ARGV)
      new.process(method, arguments)
    rescue => e
      help_for_error method, e
    end

    def help(help = nil)
      return @help = help if help
      @help ||= Ame::Help::Console.new
    end

    def help_for_dispatch(method, subclass)
      help.for_dispatch method, subclass
    end

    def help_for_method(method)
      help.for_method method
    end

  private

    def help_for_error(method, error)
      help.for_error method, error
    end

    def method_added(name)
      m = method
      option :version, 'Display version information', :ignore => true do
        help.version self, m
        throw Ame::AbortAllProcessing
      end unless method.options.include? :version
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
