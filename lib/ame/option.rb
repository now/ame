# -*- coding: utf-8 -*-

class Ame::Option < Ame::Argument
  def initialize(name, description, options = {}, &validate)
    is_boolean_type = [TrueClass, FalseClass].include? options[:type]
    options[:default] = false unless options.include? :default or options.include? :type
    if is_boolean_type and not options.include? :default
      options[:default] = options[:type] == FalseClass
    end
    is_boolean = [true, false].include? options[:default]
    if options[:optional] and not (is_boolean_type or is_boolean)
      raise ArgumentError, 'Optional arguments to options are only allowed for booleans'
    end
    options[:optional] = is_boolean
    super
  end

  def to_s
    name
  end

private

  def set_default(value, type)
    saved_optional, @optional = @optional, true
    super
  ensure
    @optional = saved_optional
  end
end
