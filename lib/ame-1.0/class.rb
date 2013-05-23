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

    # Sets the DESCRIPTION of the method about to be defined, or returns it if
    # DESCRIPTION is nil.  The description is used in help output and similar
    # circumstances.
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

    # Forces options to the method about to be defined to precede any arguments
    # to be processed correctly.
    # @return [self]
    def options_must_precede_arguments
      method.options_must_precede_arguments
      self
    end

    def flag(short, long, default, description, &validate)
      method.flag short, long, default, description, &validate
      self
    end

    def toggle(short, long, default, description, &validate)
      method.toggle short, long, default, description, &validate
      self
    end

    def switch(short, long, argument, default, argument_default, description, &validate)
      method.switch short, long, argument, default, argument_default, description, &validate
      self
    end

    def option(short, long, argument, default, description, &validate)
      method.option short, long, argument, default, description, &validate
      self
    end

    # Defines argument NAME with DESCRIPTION of TYPE, which, if OPTIONAL, has
    # DEFAULT as its value if not given.  An optional block will be used for
    # any validation or further processing, where OPTIONS are the options
    # processed so far and their values, PROCESSED are the values of the
    # arguments processed so far, and ARGUMENT is the value of the argument
    # itself.
    # @param (see Method::Undefined#argument)
    # @option (see Method::Undefined#argument)
    # @yield (see Method::Undefined#argument)
    # @yieldparam (see Method::Undefined#argument)
    # @raise (see Method::Undefined#argument)
    # @return [self]
    def argument(name, description, options = {}, &validate)
      method.argument name, description, options, &validate
      self
    end

    def optional(name, default, description, &validate)
      method.optional name, default, description, &validate
      self
    end

    # Defines splat argument NAME with DESCRIPTION of TYPE, which, if OPTIONAL,
    # has DEFAULT as its value if not given.  An optional block will be used
    # for any validation or further processing, where OPTIONS are the options
    # processed so far and their values, PROCESSED are the values of the
    # arguments processed so far, and ARGUMENT is the value of the argument
    # itself.
    # @param (see Method::Undefined#splat)
    # @option (see Method::Undefined#splat)
    # @yield (see Method::Undefined#splat)
    # @yieldparam (see Method::Undefined#splat)
    # @raise (see Method::Undefined#splat)
    # @return [self]
    def splat(name, description, options = {}, &validate)
      method.splat name, description, options, &validate
      self
    end

    def splus(name, default, description, &validate)
      method.splus name, default, description, &validate
      self
    end

    # Sets up a dispatch method to KLASS.
    # @param [Class] klass
    # @param [Hash] options
    # @option options [#to_sym] :default The default method to run; if given,
    #   method argument will be optional
    # @raise [ArgumentError] If any arguments have been defined on the method
    # @return [self]
    def dispatch(klass, options = {})
      klass.parent = self
      description klass.description
      options_must_precede_arguments
      flag '', 'help', nil, 'Display help for this method' do
        help.dispatch methods[klass.basename], klass
        throw Ame::AbortAllProcessing
      end unless method.option? :help
      method.arguments? and
        raise ArgumentError,
          'arguments may not be defined for a dispatch: %s' % klass
      if options[:default]
        optional :method, options[:default], 'Method to run'
      else
        argument :method, 'Method to run'
      end
      splat :arguments, 'Arguments to pass to METHOD', :optional => true
      define_method Ame::Method.ruby_name(klass.basename) do |method, arguments|
        klass.process method, arguments
      end
      self
    end

    # Defines the previously undefined {#method} now that it’s been added to
    # the class.
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

    # @return [Method::Undefined] The undefined method about to be defined
    def method
      @method ||= Ame::Method::Undefined.new(self)
    end

    protected

    # @return [Class] The parent of the receiver
    attr_accessor :parent

    public

    # Sets the HELP object to use for displaying usage information, or returns
    # it if HELP is nil.  The default is to delegate the request to the
    # {#parent}.
    # @param [#method, #dispatch, #error, #version] help
    # @return [#method, #dispatch, #error, #version]
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
