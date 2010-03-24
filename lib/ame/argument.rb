# -*- coding: utf-8 -*-

class Ame::Argument
  def self.parser(type, &parser)
    @@parsers ||= {}
    @@parsers[type] = parser
  end

  def initialize(name, description, options = {}, &validate)
    @name, @description, @validate = name, description, validate || proc{ |results, argument| argument }
    @optional = options[:optional] || false
    self.type = options[:type] || :string
    @default = nil
    self.default = options[:default] if options.include?(:default)
  end

  def process(results, argument)
    raise Ame::MissingArgument, "Missing argument: #{self}" if required? and argument.nil?
    @validate.call(results, parse(argument))
  end

  attr_reader :name, :description

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

  def type=(type)
    raise ArgumentError, "Unknown type: #{type}" unless parser = @@parsers[type]
    @parser = parser
  end

  def default=(value)
    raise ArgumentError, "Default can only be set if optional" unless optional?
    @parser.call "Default", value
    @default = value
  end

  def parse(argument)
    argument.nil? ? @default : @parser.call(self, argument)
  end
end

Ame::Argument.parser :boolean do |argument, value|
  if ['true', 'yes', 'on'].include? value
    true
  elsif ['false', 'no', 'off'].include? value
    false
  else
    raise Ame::MalformedArgument, "#{argument} is not a boolean: #{value}"
  end
end

Ame::Argument.parser :integer do |argument, value|
  begin
    Integer(value)
  rescue ArgumentError
    raise Ame::MalformedArgument, "#{argument} is not an integer: #{value}"
  end
end

Ame::Argument.parser :string do |argument, value|
  value
end
