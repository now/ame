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
    raise ArgumentError,
      'Boolean options cannot have argument descriptions' if
        is_boolean and options[:argument]
    @argument_name = is_boolean ? "" : (options[:argument] || name).to_s.upcase
    @aliases = Array(options[:aliases])
    super
  end

  def to_s
    (name.to_s.length > 1 ? '--%s' : '-%s') % name.to_s
  end

  attr_reader :argument_name, :aliases

  def short
    [name, *aliases].find{ |a| a.to_s.length == 1 }
  end

  def long
    [name, *aliases].find{ |a| a.to_s.length > 1 }
  end

private

  def set_default(value, type)
    saved_optional, @optional = @optional, true
    super
  ensure
    @optional = saved_optional
  end
end
