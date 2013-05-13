# -*- coding: utf-8 -*-

class Ame::Argument
  def initialize(name, description, options = {}, &validate)
    @name, @description, @validate = name.to_sym, description, validate || DefaultValidate
    @optional = options.fetch(:optional, false)
    @type = Ame::Types[[options[:type], options[:default], String].find{ |o| !o.nil? }]
    set_default options[:default], options[:type] if options.include? :default
  end

  def arity
    1
  end

  def process(options, processed, argument)
    raise Ame::MissingArgument, 'missing argument: %s' % self if required? and argument.nil?
    validate(options, processed, argument)
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

  DefaultValidate = proc{ |options, processed, argument| argument }

  def set_default(value, type)
    raise ArgumentError,
      'default value can only be set if optional' unless optional?
    raise ArgumentError,
      'default value %s is not of type %s' %
        [value, type] unless value.nil? or type.nil? or value.is_a? type
    @default = value
  end

  def parse(argument)
    argument.nil? ? default : @type.parse(argument)
  end

  def validate(options, processed, argument)
    @validate.call(options, processed, parse(argument))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end
end
