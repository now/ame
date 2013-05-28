# -*- coding: utf-8 -*-

# A {Method} in its undefined state.  This class is used to construct the
# method before it gets defined, setting up a description, specifying that
# options_must_precede_arguments, adding flags, toggles, switches, options,
# multioptions, arguments, optional arguments, splats, spluses, and finally
# defining it.
# @api developer
class Ame::Method::Undefined
  # Sets up an as yet undefined method on KLASS.
  # @api internal
  # @param [Class] klass
  def initialize(klass)
    @class = klass
    @description = nil
    @options = Ame::Options::Undefined.new
    @arguments = Ame::Arguments::Undefined.new
  end

  # Sets the DESCRIPTION of the method, or returns it if DESCRIPTION is nil.
  # The description is used in help output and similar circumstances.
  # @api internal
  # @param [String, nil] description
  # @return [String]
  def description(description = nil)
    return @description unless description
    @description = description
    self
  end

  # Forces options to the method to precede any arguments to be processed
  # correctly.
  # @api internal
  # @return [self]
  def options_must_precede_arguments
    @options.options_must_precede_arguments
    self
  end

  # Delegates {Class.flag} to {Options::Undefined#flag}.
  # @api internal
  # @param (see Options::Undefined#flag)
  # @yield (see Options::Undefined#flag)
  # @yieldparam (see Options::Undefined#flag)
  # @raise (see Options::Undefined#flag)
  # @return [self]
  def flag(short, long, default, description, &validate)
    @options.flag short, long, default, description, &validate
    self
  end

  # Delegates {Class.toggle} to {Options::Undefined#toggle}.
  # @api internal
  # @param (see Options::Undefined#toggle)
  # @yield (see Options::Undefined#toggle)
  # @yieldparam (see Options::Undefined#toggle)
  # @raise (see Options::Undefined#toggle)
  # @return [self]
  def toggle(short, long, default, description, &validate)
    @options.toggle short, long, default, description, &validate
    self
  end

  # Delegates {Class.switch} to {Options::Undefined#switch}.
  # @api internal
  # @param (see Options::Undefined#switch)
  # @yield (see Options::Undefined#switch)
  # @yieldparam (see Options::Undefined#switch)
  # @raise (see Options::Undefined#switch)
  # @return [self]
  def switch(short, long, argument, default, argument_default, description, &validate)
    @options.switch short, long, argument, default, argument_default, description, &validate
    self
  end

  # Delegates {Class.option} to {Options::Undefined#option}.
  # @api internal
  # @param (see Options::Undefined#option)
  # @yield (see Options::Undefined#option)
  # @yieldparam (see Options::Undefined#option)
  # @raise (see Options::Undefined#option)
  # @return [self]
  def option(short, long, argument, default, description, &validate)
    @options.option short, long, argument, default, description, &validate
    self
  end

  # Delegates {Class.multioption} to {Options::Undefined#multioption}.
  # @api internal
  # @param (see Options::Undefined#multioption)
  # @yield (see Options::Undefined#multioption)
  # @yieldparam (see Options::Undefined#multioption)
  # @raise (see Options::Undefined#multioption)
  # @return [self]
  def multioption(short, long, argument, type, description, &validate)
    @options.multioption short, long, argument, type, description, &validate
    self
  end

  # Delegates {Class.argument} to {Arguments::Undefined#argument}.
  # @api internal
  # @param (see Arguments::Undefined#argument)
  # @yield (see Arguments::Undefined#argument)
  # @yieldparam (see Arguments::Undefined#argument)
  # @raise (see Arguments::Undefined#argument)
  # @raise (see Arguments::Optional#argument)
  # @raise (see Arguments::Complete#argument)
  # @return [self]
  def argument(name, type, description, &validate)
    @arguments.argument(name, type, description, &validate)
    self
  end

  # Delegates {Class.argument} to {Arguments::Undefined#optional} or
  # {Arguments::Optional#optional}.
  # @api internal
  # @param (see Arguments::Undefined#optional)
  # @yield (see Arguments::Undefined#optional)
  # @yieldparam (see Arguments::Undefined#optional)
  # @param (see Arguments::Undefined#optional)
  # @raise (see Arguments::Undefined#optional)
  # @raise (see Arguments::Complete#optional)
  # @return [self]
  def optional(name, default, description, &validate)
    @arguments = @arguments.optional(name, default, description, &validate)
    self
  end

  # Delegates {Class.argument} to {Arguments::Undefined#splat}.
  # @api internal
  # @param (see Arguments::Undefined#splat)
  # @option (see Arguments::Undefined#splat)
  # @yield (see Arguments::Undefined#splat)
  # @yieldparam (see Arguments::Undefined#splat)
  # @raise (see Arguments::Undefined#splat)
  # @raise (see Arguments::Complete#splat)
  # @return [self]
  def splat(name, type, description, &validate)
    @arguments = @arguments.splat(name, type, description, &validate)
    self
  end

  # Delegates {Class.argument} to {Arguments::Undefined#splus}.
  # @api internal
  # @param (see Arguments::Undefined#splus)
  # @option (see Arguments::Undefined#splus)
  # @yield (see Arguments::Undefined#splus)
  # @yieldparam (see Arguments::Undefined#splus)
  # @raise (see Arguments::Undefined#splus)
  # @raise (see Arguments::Optional#splus)
  # @raise (see Arguments::Complete#splus)
  # @return [self]
  def splus(name, type, description, &validate)
    @arguments = @arguments.splus(name, type, description, &validate)
    self
  end

  # @api internal
  # @return [Method] The method RUBY_NAME after adding a “help” flag that’ll
  #   display help via {Class.help}#method and raise {AbortAllProcessing}
  def define(ruby_name)
    flag '', 'help', nil, 'Display help for this method' do
      @class.help.method @class.methods[Ame::Method.name(ruby_name)]
      throw Ame::AbortAllProcessing
    end unless @options.include? 'help'
    Ame::Method.new(ruby_name, @class, @description, @options.define, @arguments.define)
  end

  # @param [String] option
  # @return [Boolean] True if OPTION has been defined on the receiver
  def option?(option)
    @options.include? option
  end

  # @return [Boolean] True if any arguments have been defined on the receiver
  def arguments?
    not @arguments.empty?
  end

  # @return [Boolean] True if a description has been defined on the receiver
  def valid?
    not description.nil?
  end
end
