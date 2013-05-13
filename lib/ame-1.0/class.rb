# -*- coding: utf-8 -*-

# The superclass of a Ruby class that wants to be able to be invoked from the
# command line (or with any list of String options and arguments).  Subclassed
# by {Root}, which should be used as the root of any command-line processing
# interface.
# @example A Git-like Command-line Interface With Ame
#   class Git::CLI < Ame::Root
#     version '1.0.0'
#     dispatch Git
#   end
#   class Git::CLI::Git < Ame::Class
#     description 'The stupid content tracker'
#     def initialize; end
#
#     description 'Show various types of objects
#     option :'abbrev-commit', 'Show only partial prefix'
#     splat :objects, 'The names of objects to show'
#     def show(objects, options = {})
#       …
#     end
#
#     dispatch Remote
#   end
#   class Git::CLI::Git::Remote < Ame::Class
#     description 'Manage set of remote repositories'
#     def initialize; end
#
#     description 'Adds a remote named NAME for the repository at URL'
#     argument :name, 'Name of the remote to add'
#     argument :url, 'URL to the repository of the remote to add'
#     def add(name, url)
#       …
#     end
#   end
#   Git::CLI.process
class Ame::Class
  class << self
    # Process ARGUMENTS as a list of options and arguments, then call METHOD
    # with the results of this processing on a new instance of the receiver.
    # This method catches {AbortProcessing}.
    # @param [#to_sym] method
    # @param [Array<String>] arguments
    # @return [self]
    # @see Methods#process
    def process(method, arguments = [])
      catch Ame::AbortProcessing do
        methods[method].process new, arguments
      end
      self
    end

    # Call METHOD with ARGUMENTS and OPTIONS on a new instance of the receiver.
    # This method catches {AbortProcessing}.
    # @param [#to_sym] method
    # @param [Array] arguments
    # @param [Hash] options
    # @return [self]
    # @see Methods#call
    def call(method, arguments = nil, options = nil)
      catch Ame::AbortProcessing do
        methods[method].call new, arguments, options
      end
      self
    end

    # Sets or returns, depending on if DESCRIPTION is nil or not, the
    # description of the method currently being defined.  The description can
    # be used in help output and similar circumstances.
    #
    # @param [String, nil] description
    # @return [String]
    # @example Set The Description of the #Push Method
    #   class Button
    #     description 'Push the button'
    #     def push
    def description(description = nil)
      return method.description(description) if description
      defined?(@description) ? @description : ''
    end

    private

    # Forces options to the method being defined to precede any arguments to be
    # processed correctly.
    # @return [self]
    def options_must_precede_arguments
      method.options_must_precede_arguments
      self
    end

    # Defines option NAME with DESCRIPTION, configured with OPTIONS, using an
    # optional block for any validation or further processing.
    # @param (see Method#option)
    # @yield (see Method#option)
    # @yieldparam (see Method#option)
    # @option (see Method#option)
    # @return [self]
    def option(name, description, options = {}, &validate)
      method.option name, description, options, &validate
      self
    end

    # Defines argument NAME with DESCRIPTION, configured with OPTIONS, using an
    # optional block for any validation or further processing.
    # @param (see Method#option)
    # @yield (see Method#option)
    # @yieldparam (see Method#option)
    # @option (see Method#option)
    # @return [self]
    def argument(name, description, options = {}, &validate)
      method.argument name, description, options, &validate
      self
    end

    # Defines splat NAME with DESCRIPTION, configured with OPTIONS, using an
    # optional block for any validation or further processing.
    # @param (see Method#option)
    # @yield (see Method#option)
    # @yieldparam (see Method#option)
    # @option (see Method#option)
    # @return [self]
    def splat(name, description, options = {}, &validate)
      method.splat name, description, options, &validate
      self
    end

    # Sets up a dispatch method to KLASS.
    # @raise [ArgumentError] If any arguments have been defined on the method
    # @return [self]
    def dispatch(klass, options = {})
      klass.parent = self
      description klass.description
      options_must_precede_arguments
      option :help, 'Display help for this method', :ignore => true do
        help.dispatch methods[klass.basename], klass
        throw Ame::AbortAllProcessing
      end unless options.include? :help
      method.arguments.arity.zero? or
        raise ArgumentError,
          'arguments may not be defined for a dispatch: %s' % klass
      argument :method, 'Method to run', options.include?(:default) ?
        {:optional => true, :default => options[:default]} :
        {}
      splat :arguments, 'Arguments to pass to METHOD', :optional => true
      define_method Ame::Method.ruby_name(klass.basename) do |method, arguments|
        klass.process method, arguments
      end
      self
    end

    # Defines the {#method} currently being defined.
    # @raise [ArgumentError] If RUBY_NAME is the name of a non-public method
    #   that’s being defined
    # @return [self]
    def method_added(ruby_name)
      if ruby_name == :initialize
        @description = method.define(ruby_name).description
      elsif public_method_defined? ruby_name
        methods << method.define(ruby_name)
      elsif method.valid?
        raise ArgumentError, 'non-public method cannot be used by Ame: %s' % ruby_name
      end
      @method = nil
      self
    end

    # @return [Method] The method currently being defined
    def method
      @method ||= Ame::Method::Undefined.new(self)
    end

    protected

    # @return [Class] The parent of the receiver
    attr_accessor :parent

    public

    # Sets or returns, depending on if HELP is nil or not, the help object to
    # use for displaying usage information.  The default is to delegate the
    # request to the {#parent}.
    def help(help = nil)
      return @help = help if help
      @help ||= Ame::Help::Delegate.new(parent.help)
    end

    # Sets or returns, depending on if BASENAME is nil or not, the basename
    # of the receiver.  The basename is the downcased last component of the
    # double-colon-separated name of the class with all camel-cased sub-words
    # separated by dashes.
    # @example Basename of A::B::CToTheD
    #   class A::B::CToTheD < Ame::Class; end
    #   A::B::CToTheD.basename # ⇒ "c-to-the-d"
    # @param [String, nil] basename
    # @return [String]
    def basename(basename = nil)
      @basename = basename if basename
      return @basename if defined? @basename
      name.split('::').last.scan(/[[:upper:]][[:lower:]]*/).join('-').downcase
    end

    # @return [String] The full name of the space-separated concatenation of
    #   the basenames of the receiver and its {#parent}s
    # @example Fullname of A::B::CToTheD
    #   class A::B::CToTheD < Ame::Class; end
    #   A::B::CToTheD.fullname # ⇒ "a b c-to-the-d"
    def fullname
      [].tap{ |names|
        klass = self
        until klass.nil? or klass.basename.empty?
          names << klass.basename
          klass = klass.parent
        end
      }.reverse.join(' ')
    end

    # @return [Methods] The methods defined on the receiver
    def methods
      @methods ||= Ame::Methods.new
    end
  end
end
