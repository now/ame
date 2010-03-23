# -*- coding: utf-8 -*-

class Ame::Arguments
  def initialize
    @arguments = []
    @splat = nil
  end

  def argument(name, description, options = {}, &block)
    argument = Ame::Argument.new(name, description, options, &block)
    optional = @arguments.find{ |a| a.optional? }
    raise ArgumentError,
      'Required argument %s must come before optional argument %s' %
        [argument.name, optional.name] if argument.required? and optional
    @arguments << argument
    self
  end

  def splat(name, description, options = {}, &validate)
    raise ArgumentError, "Splat argument #{@splat.name} already defined: #{name}" if @splat
    @splat = Ame::Splat.new(name, description, options, &validate)
    self
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
end
