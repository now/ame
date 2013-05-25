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
      @version
    end

    private

    def method_added(ruby_name)
      unless method.option? 'version'
        raise ArgumentError, 'version not set, set it with version VERSION', caller unless defined? @version
        flag '', 'version', nil, 'Display version information' do
          help.version methods[Ame::Method.name(ruby_name)], self.version
          throw Ame::AbortAllProcessing
        end
      end
      super
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end
  end
end
