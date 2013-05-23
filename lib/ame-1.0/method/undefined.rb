# -*- coding: utf-8 -*-

# A {Method} in its undefined state.  This class is used to construct the
# method before it gets defined, setting up a {#description}, specifying that
# {#options_must_precede_arguments}, adding {#option}s, {#argument}s, and
# {#splat}s, and finally {#define}ing it.
class Ame::Method::Undefined
  # Sets up an as yet undefined method on KLASS.
  # @param [Class] klass
  def initialize(klass)
    @class = klass
    @description = nil
    @options = Ame::Options::Undefined.new
    @arguments = Ame::Arguments::Undefined.new
  end

  # Sets the DESCRIPTION of the method, or returns it if DESCRIPTION is nil.
  # The description is used in help output and similar circumstances.
  # @param [String, nil] description
  # @return [String]
  def description(description = nil)
    return @description unless description
    @description = description
    self
  end

  # Forces options to the method to precede any arguments to be processed
  # correctly.
  # @return [self]
  def options_must_precede_arguments
    @options.options_must_precede_arguments
    self
  end

  def flag(short, long, default, description, &validate)
    @options.flag short, long, default, description, &validate
    self
  end

  def toggle(short, long, default, description, &validate)
    @options.toggle short, long, default, description, &validate
    self
  end

  def switch(short, long, argument, default, argument_default, description, &validate)
    @options.switch short, long, argument, default, argument_default, description, &validate
    self
  end

  def option(short, long, argument, default, description, &validate)
    @options.option short, long, argument, default, description, &validate
    self
  end

  # Defines argument NAME with DESCRIPTION of TYPE, which, if OPTIONAL, has
  # DEFAULT as its value if not given.  An optional block will be used for any
  # validation or further processing, where OPTIONS are the options processed
  # so far and their values, PROCESSED are the values of the arguments
  # processed so far, and ARGUMENT is the value of the argument itself.
  # @param (see Arguments::Undefined#argument)
  # @option (see Arguments::Undefined#argument)
  # @yield (see Arguments::Undefined#argument)
  # @yieldparam (see Arguments::Undefined#argument)
  # @raise (see Arguments::Undefined#argument)
  # @return [self]
  def argument(name, description, options = {}, &validate)
    @arguments.argument name, description, options, &validate
    self
  end

  def optional(name, default, description, &validate)
    @arguments.optional name, default, description, &validate
    self
  end

  # Defines splat argument NAME with DESCRIPTION of TYPE, which, if OPTIONAL,
  # has DEFAULT as its value if not given.  An optional block will be used for
  # any validation or further processing, where OPTIONS are the options
  # processed so far and their values, PROCESSED are the values of the
  # arguments processed so far, and ARGUMENT is the value of the argument
  # itself.
  # @param (see Arguments::Undefined#splat)
  # @option (see Arguments::Undefined#splat)
  # @yield (see Arguments::Undefined#splat)
  # @yieldparam (see Arguments::Undefined#splat)
  # @raise (see Arguments::Undefined#splat)
  # @return [self]
  def splat(name, description, options = {}, &validate)
    @arguments.splat name, description, options, &validate
    self
  end

  def define(ruby_name)
    flag '', 'help', nil, 'Display help for this method' do
      @class.help.method @class.methods[Ame::Method.name(ruby_name)]
      throw Ame::AbortAllProcessing
    end unless @options.include? 'help'
    Ame::Method.new(ruby_name, @class, @description, @options.define, @arguments.define)
  end

  def option?(option)
    @options.include? option
  end

  def arguments?
    not @arguments.empty?
  end

  def valid?
    not description.nil?
  end
end
