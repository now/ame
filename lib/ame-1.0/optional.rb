# -*- coding: utf-8 -*-

class Ame::Optional
  def initialize(name, default, description, &validate)
    @name, @default, @description, @validate = name.to_sym, default, description, validate || DefaultValidate
    @type = Ame::Types[[default, String].find{ |o| !o.nil? }]
  end

  # @return [Symbol] The name of the receiver
  attr_reader :name

  # @return [String] The description of the receiver
  attr_reader :description

  # @return [Object, nil] The default value of the receiver
  attr_reader :default

  def process(options, processed, arguments)
    @validate.call(options, processed, arguments.empty? ? default : @type.parse(arguments.shift))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end

  # @return [String] The upcasing of the {#name} of the receiver
  def to_s
    name.to_s.upcase
  end

  private

  DefaultValidate = proc{ |options, processed, argument| argument }
end
