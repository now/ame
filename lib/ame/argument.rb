# -*- coding: utf-8 -*-

class Ame::Argument
  def initialize(name, description, options = {}, &validate)
    @name, @description, @validate = name, description, validate || proc{ |results, argument| argument }
    @optional = options[:optional] || false
    @type = Ame::Types[[options[:type], options[:default], String].find{ |o| !o.nil? }]
    set_default options[:default], options[:type] if options.include? :default
  end

  def process(results, argument)
    raise Ame::MissingArgument, "Missing argument: #{self}" if required? and argument.nil?
    @validate.call(results, @type.parse(self, argument))
  end

  attr_reader :name, :description, :default

  def optional?
    @optional
  end

  def required?
    not optional?
  end

  def to_s
    (optional? ? '[%s]' : '%s') % [argument_name]
  end

private

  def argument_name
    name.to_s.upcase
  end

  def set_default(value, type)
    raise ArgumentError,
      'Default value can only be set if optional' unless optional?
    raise ArgumentError,
      'Default value %s is not of type %s' %
        [value, type] unless value.nil? or type.nil? or value.is_a? type
    @default = value
  end
end
