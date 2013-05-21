# -*- coding: utf-8 -*-

class Ame::Root < Ame::Class
  class << self
    def basename
      ''
    end

    def process(method = File.basename($0), arguments = ARGV)
      catch Ame::AbortAllProcessing do
        super
      end
      self
    rescue => e
      help.error method, e
    end

    def call(method, arguments = nil, options = nil)
      catch Ame::AbortAllProcessing do
        super
      end
      self
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

    private

    def method_added(ruby_name)
      flag '', 'version', nil, 'Display version information' do
        help.version methods[Ame::Method.name(ruby_name)], self.version
        throw Ame::AbortAllProcessing
      end unless method.option? :version
      super
    end
  end
end
