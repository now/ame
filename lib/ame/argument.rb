# -*- coding: utf-8 -*-

class Ame::Argument
  def initialize(name, description, options = {}, &validate)
    @name, @description, @validate = name, description, validate || proc{ |options, processed, argument| argument }
    @optional = options[:optional] || false
    @type = Ame::Types[[options[:type], options[:default], String].find{ |o| !o.nil? }]
    set_default options[:default], options[:type] if options.include? :default
  end

  def arity
    1
  end

  def process(options, processed, argument)
    raise Ame::MissingArgument, 'missing argument: %s' % self if required? and argument.nil?
    @validate.call(options, processed, parse(argument))
  end

  attr_reader :name, :description, :default

  def optional?
    @optional
  end

  def required?
    not optional?
  end

  def to_s
    name.to_s.upcase
  end

private

  def parse(argument)
    argument.nil? ? default : @type.parse(argument)
  rescue Ame::MalformedArgument => e
    raise e.exception('%s: %s' % [self, e])
  end

  def set_default(value, type)
    raise ArgumentError,
      'default value can only be set if optional' unless optional?
    raise ArgumentError,
      'default value %s is not of type %s' %
        [value, type] unless value.nil? or type.nil? or value.is_a? type
    @default = value
  end
end
