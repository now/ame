# -*- coding: utf-8 -*-

require 'facets/kernel/tap'
require 'forwardable'

module Ame
  Error = Class.new(StandardError)
  MalformedArgument = Class.new(Error)
  MissingArgument = Class.new(Error)
  UnrecognizedOption = Class.new(Error)

  autoload :Argument, 'ame/argument'
  autoload :Arguments, 'ame/arguments'
  autoload :Class, 'ame/class'
  autoload :Help, 'ame/help'
  autoload :Method, 'ame/method'
  autoload :Methods, 'ame/methods'
  autoload :Option, 'ame/option'
  autoload :Options, 'ame/options'
  autoload :Splat, 'ame/splat'
  autoload :Types, 'ame/types'
  autoload :Version, 'ame/version'

=begin
  def initialize(version, command = File.basename($PROGRAM_NAME), name = command)
    @optionsparser = OptionParser.new{ |o|
      o.on_tail '-h', '--help', 'Show this message' do
        $stderr.puts o
        exit
      end

      o.on_tail '-V', '--version', 'Show version information' do
        $stderr.puts "#{name} v#{version}"
        exit
      end
    }
    @optionsparser.program_name = command
    @optionsparser.version = version
    @options = OpenStruct.new
    @arguments = Arguments.new
    yield Definition.new(@optionsparser, @options, @arguments)
    @optionsparser.banner = "Usage: ".tap{ |b|
      b << command
      b << ' [OPTION]...' unless @optionsparser.to_a.empty?
      unless @arguments.to_s.empty?
        b << ' '
        b << @arguments.to_s
      end
    }
  end

  def parse!(arguments = ARGV)
    result = [@options, @arguments.process(@optionsparser.parse(arguments))]
    return result unless block_given?
    yield result[0], *result[1]
  rescue StandardError => e
    $stderr.puts "#{@optionsparser.program_name}: #{e.message}"
    $stderr.puts @optionsparser.banner
    exit 1
  end
=end

#  require 'ample/utilities/commandline/arguments'
end
