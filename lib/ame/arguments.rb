# -*- coding: utf-8 -*-

require 'facets/kernel/tap'

require 'ame/argument'
require 'ame/splat'

class Ame; end

class Ame::Arguments
  def initialize
    @arguments = []
    @splat = nil
  end

  def argument(name, description, options = {}, &block)
    if options.fetch(:optional, false) and optional = @arguments.first{ |argument| argument.optional? }
      raise ArgumentError,
        "Required argument #{name} must come before optional argument #{optional.name}"
    end
    @arguments << Ame::Argument.new(name, description, options, &block)
  end

  def splat(name, description, options = {}, &validate)
    raise ArgumentError, "Splat argument #{splat.name} already defined: #{name}" if @splat
    @splat = Ame::Splat.new(name, description, options, &validate)
  end

  def count
    @arguments.size
  end

=begin
  def process(arguments)
    [].tap{ |results|
      @arguments.each do |argument|
        results << argument.process(results, arguments.shift)
      end
      results << @splat.process(results, arguments) if @splat
    }
  end

  def to_s
    @arguments.map{ |argument| argument.to_s).join(' ').tap{ |s|
      if @splat
        s << ' ' unless s.empty?
        s << @splat.to_s
      end
    }
  end
=end

#  require 'ample/utilities/commandline/arguments/argument'
#  require 'ample/utilities/commandline/arguments/splat'
end
