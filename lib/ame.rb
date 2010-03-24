# -*- coding: utf-8 -*-

require 'facets/kernel/tap'
require 'forwardable'

class Ame
  autoload :Action, 'ame/action'
  autoload :Actions, 'ame/actions'
  autoload :Argument, 'ame/argument'
  autoload :Arguments, 'ame/arguments'
  autoload :Option, 'ame/option'
  autoload :Options, 'ame/options'
  autoload :Splat, 'ame/splat'
  autoload :Version, 'ame/version'

  Error = Class.new(StandardError)
  MalformedArgument = Class.new(Error)
  MissingArgument = Class.new(Error)
  UnrecognizedOption = Class.new(Error)

  self.extend SingleForwardable

  self.def_delegators :action, :description, :option, :argument, :splat

  def self.method_added(name)
    return unless public_instance_methods.map{ |m| m.to_sym }.include? name
    actions[name] = action if action.defined?
    self.action = Action.new
  end

  def self.process
    raise NotImplementedError, "initialize action must be defined" unless initialize = actions[:initialize]
    if actions.size > 1
      unless initialize.arity.zero?
        raise NotImplementedError,
          "initialize action must not have arguments if other actions have been defined"
      end
      initialize.argument :action, "Action to run"
    end
  end

private

  def self.actions
    @actions ||= Actions.new
  end

  def self.action
    @action ||= Action.new
  end

  def self.action=(action)
    @action = action
  end

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
