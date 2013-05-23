# -*- coding: utf-8 -*-

class Ame::Optional < Ame::Argument
  def initialize(name, default, description, &validate)
    @default = default
    super name, Ame::Types[[default, String].reject(&:nil?).first], description, &validate
  end

  # @return [Object, nil] The default value of the receiver
  attr_reader :default

  def process(options, processed, arguments)
    @validate.call(options, processed, arguments.empty? ? default : @type.parse(arguments.shift))
  rescue Ame::MalformedArgument, ArgumentError, TypeError => e
    raise Ame::MalformedArgument, '%s: %s' % [self, e]
  end
end
