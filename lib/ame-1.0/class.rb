# -*- coding: utf-8 -*-

# The superclass of a Ruby class that wants to be able to be invoked from the
# command line (or with any list of String options and arguments).  Subclassed
# by {Root}, which should be used as the root of any command-line processing
# interface.  See {Root} for an example.
class Ame::Class
  class << self
    # Process ARGUMENTS as a list of options and arguments, then call METHOD
    # with the results of this processing on a new instance of the receiver.
    # This method catches {AbortProcessing}.  Options are arguments that begin
    # with `-` or `--`.  If {.options_must_precede_arguments} has been called
    # on the receiver, then options must precede arguments.  Either way, a `--`
    # argument will always end the processing of options and begin processing
    # of arguments instead.
    # @param [#to_sym] method
    # @param [Array<String>] arguments
    # @raise (see Method#process)
    # @raise [UnrecognizedMethod] If the method argument to a dispatch isn’t a
    #   known method
    # @return [self]
    def process(method, arguments = [])
      catch Ame::AbortProcessing do
        methods[method].process new, arguments
      end
      self
    end

    # Call METHOD with ARGUMENTS and OPTIONS on a new instance of the receiver.
    # This method catches {AbortProcessing}.  Options are arguments that begin
    # with `-` or `--`.  If {.options_must_precede_arguments} has been called
    # on the receiver, then options must precede arguments.  Either way, a `--`
    # argument will always end the processing of options and begin processing
    # of arguments instead.
    # @param [#to_sym] method
    # @param [Array] arguments
    # @param [Hash<String, Object>] options
    # @raise (see Method#call)
    # @raise [UnrecognizedMethod] If the method argument to a dispatch isn’t a
    #   known method
    # @return [self]
    def call(method, arguments = nil, options = nil)
      catch Ame::AbortProcessing do
        methods[method].call new, arguments, options
      end
      self
    end

    # Sets the DESCRIPTION of the method about to be defined, or returns it if
    # DESCRIPTION is nil.  The description is used in help output and similar
    # circumstances.  A description can only be given to a public method, as
    # only public methods can be used as Ame methods.
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

    # Forces options to the method about to be defined to precede any
    # arguments, lest they be seen as arguments.  If not given, the behaviour
    # will depend on whether `ENV['POSIXLY_CORRECT']` has been set or not.
    # @return [self]
    def options_must_precede_arguments
      method.options_must_precede_arguments
      self
    end

    # Defines SHORT and/or LONG as a boolean flag with DEFAULT and DESCRIPTION.
    # An optional block will be used for any validation or further processing
    # of the parsed value of the argument, where OPTIONS are the options
    # processed so far and their values and VALUE is the parsed value itself or
    # the inverse of DEFAULT, if no argument was passed.  An argument isn’t
    # required, but if one is to be explicitly given, it must be passed as
    # `-SHORT=ARGUMENT` or `--LONG=ARGUMENT` and may be given as any of “true”,
    # “yes”, “on” or “false”, “no”, “off”.  Multiple short flags may be
    # juxtaposed as `-abc`.
    # @param (see Method::Undefined#flag)
    # @yield (see Method::Undefined#flag)
    # @yieldparam (see Method::Undefined#flag)
    # @raise (see Method::Undefined#flag)
    # @return [self]
    # @example A Couple of Flags
    #   class Git::CLI::Git::FormatPatch < Ame::Class
    #     flag   ?n, 'numbered', false, 'Name output in [PATCH n/m] format'
    #     flag   ?N, 'no-numbered', nil, 'Name output in [PATCH] format' do |opt|
    #       opt['numbered'] = false
    #      end
    #   end
    def flag(short, long, default, description, &validate)
      method.flag short, long, default, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Defines SHORT and/or LONG as a boolean toggle with DEFAULT and
    # DESCRIPTION.  A toggle acts like a flag, but also supports `--no-LONG`
    # for explicitly specifying that the inverse of the inverse of the default
    # should be used.  An optional block will be used for any validation or
    # further processing of the parsed value of the argument, where OPTIONS are
    # the options processed so far and their values and VALUE is the parsed
    # value itself or the inverse of DEFAULT, if no argument was passed.  An
    # argument isn’t required, but if one is to be explicitly given, it must be
    # passed as `-SHORT=ARGUMENT` or `--LONG=ARGUMENT` and may be given as any
    # of “true”, “yes”, “on” or “false”, “no”, “off”.  Multiple short toggles
    # may be juxtaposed as `-abc`.
    # @param (see Method::Undefined#toggle)
    # @yield (see Method::Undefined#toggle)
    # @yieldparam (see Method::Undefined#toggle)
    # @raise (see Method::Undefined#toggle)
    # @return [self]
    # @example A Toggle
    #   class Git::CLI::Git::FormatPatch < Ame::Class
    #     toggle ?s, 'signoff', false,
    #       'Add Signed-off-by: line to the commit message'
    #   end
    def toggle(short, long, default, description, &validate)
      method.toggle short, long, default, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Defines SHORT and/or LONG as a switch with DEFAULT taking ARGUMENT with
    # ARGUMENT_DEFAULT and DESCRIPTION.  A switch acts like an option, but the
    # argument is optional and defaults to ARGUMENT_DEFAULT.  An optional block
    # will be used for any validation or further processing of the parsed value
    # of the argument, where OPTIONS are the options processed so far and their
    # values and VALUE is the parsed value itself or ARGUMENT_DEFAULT, if no
    # argument was passed.  An argument must be passed as `-SHORT=ARG`, or
    # `--LONG=ARG`.  Multiple short switches may be juxtaposed as `-abc`.  The
    # type of the argument is determined by the type of ARGUMENT_DEFAULT, or
    # the type of DEFAULT if ARGUMENT_DEFAULT is nil.  If both are nil, String
    # will be used.  Also, if ARGUMENT_DEFAULT’s type responds to \#default,
    # the result of invoking it will be used as the default value of the
    # argument.  See {Types::Enumeration} for an example of a type that abuses
    # this fact.
    # @param (see Method::Undefined#switch)
    # @yield (see Method::Undefined#switch)
    # @yieldparam (see Method::Undefined#switch)
    # @raise (see Method::Undefined#switch)
    # @return [self]
    # @example A Switch Using An Enumeration
    #   class Git::CLI::Git::FormatPatch < Ame::Class
    #     switch '', 'thread', 'STYLE', nil,
    #       Ame::Types::Enumeration[:shallow, :deep],
    #       'Controls addition of In-Reply-To and References headers'
    #     flag   '', 'no-thread', nil,
    #       'Disables addition of In-Reply-To and Reference headers' do |o, _|
    #        o.delete 'thread'
    #     end
    #   end
    def switch(short, long, argument, default, argument_default, description, &validate)
      method.switch short, long, argument, default, argument_default, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Defines SHORT and/or LONG as an option with DEFAULT and DESCRIPTION.  An
    # option always takes an argument. An optional block will be used for any
    # validation or further processing of the parsed value of the argument,
    # where OPTIONS are the options processed so far and their values and VALUE
    # is the parsed value itself. An argument may be passed as
    # <code>-<em>short</em>ARG</code>, `-SHORT=ARG`, or `--LONG=ARG` or as
    # `-SHORT ARG` or `--LONG ARG`.  Multiple short options can thus not be
    # juxtaposed, as anything following the short option will be used as an
    # argument.  The type of the argument is determined by the type of DEFAULT,
    # or String if it’s nil.
    # @param (see Method::Undefined#option)
    # @yield (see Method::Undefined#option)
    # @yieldparam (see Method::Undefined#option)
    # @raise (see Method::Undefined#option)
    # @return [self]
    # @example An Option
    #   class Git::CLI::Git::FormatPatch < Ame::Class
    #     option '', 'start-number', 'N', 1,
    #       'Start numbering the patches at N instead of 1'
    #   end
    def option(short, long, argument, default, description, &validate)
      method.option short, long, argument, default, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Defines SHORT and/or LONG as a multi-option that takes arguments of TYPE
    # and has DESCRIPTION.  A multi-option always takes an argument and may be
    # given any number of times.  Each parsed value of each argument will be
    # added to an Array that’s stored in the OPTIONS Hash instead of the usual
    # atom types used for the other forms of options.  An optional block will
    # be used for any validation or further processing of the parsed value of
    # the argument, where OPTIONS are the options processed so far and their
    # values and VALUE is the parsed value itself. An argument may be passed as
    # <code>-<em>short</em>ARG</code>, `-SHORT=ARG`, or `--LONG=ARG` or as
    # `-SHORT ARG` or `--long ARG`.  Multiple short options can thus not be
    # juxtaposed, as anything following the short option will be used as an
    # argument.
    # @param (see Method::Undefined#multioption)
    # @yield (see Method::Undefined#multioption)
    # @yieldparam (see Method::Undefined#multioption)
    # @raise (see Method::Undefined#multioption)
    # @return [self]
    # @example An Option
    #   class Git::CLI::Git::FormatPatch < Ame::Class
    #     multioption '', 'to', 'address', String,
    #       'Add a To: header to the email headers'
    #   end
    def multioption(short, long, argument, type, description, &validate)
      method.multioption short, long, argument, type, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Defines argument NAME of TYPE with DESCRIPTION.  An optional block will
    # be used for any validation or further processing of the parsed value of
    # the argument, where OPTIONS are the options processed so far and their
    # values, PROCESSED are the values of the arguments processed so far, and
    # VALUE is the parsed value itself.
    # @param (see Method::Undefined#argument)
    # @yield (see Method::Undefined#argument)
    # @yieldparam (see Method::Undefined#argument)
    # @raise (see Method::Undefined#argument)
    # @return [self]
    # @example An Argument
    #   class Git::CLI::Git::Annotate < Ame::Class
    #     argument 'FILE', String, 'File to annotate'
    #   end
    def argument(name, type, description, &validate)
      method.argument name, type, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Defines optional argument NAME with DEFAULT and DESCRIPTION.  An optional
    # block will be used for any validation or further processing of the parsed
    # value of the argument, where OPTIONS are the options processed so far and
    # their values, PROCESSED are the values of the arguments processed so far,
    # and VALUE is the parsed value itself or DEFAULT, if no argument was
    # given.
    # @param (see Method::Undefined#optional)
    # @yield (see Method::Undefined#optional)
    # @yieldparam (see Method::Undefined#optional)
    # @raise (see Method::Undefined#optional)
    # @return [self]
    # @example An Optional Argument
    #   class Git::CLI::Git::FormatPatch < Ame::Class
    #     optional 'SINCE', String, 'Generate patches for commits after SINCE'
    #   end
    def optional(name, default, description, &validate)
      method.optional name, default, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Defines splat argument NAME of TYPE with DESCRIPTION.  A splat argument
    # may be given zero or more times.  An optional block will be used for any
    # validation or further processing, where OPTIONS are the options processed
    # so far and their values, PROCESSED are the values of the arguments
    # processed so far, and ARGUMENT is the parsed value itself.
    # @param (see Method::Undefined#splat)
    # @yield (see Method::Undefined#splat)
    # @yieldparam (see Method::Undefined#splat)
    # @raise (see Method::Undefined#splat)
    # @return [self]
    # @example A Splat Argument
    #   class Git::CLI::Git::Add < Ame::Class
    #     splat 'PATHSPEC', String, 'Files to add content from'
    #   end
    def splat(name, type, description, &validate)
      method.splat name, type, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Defines required splat argument NAME of TYPE with DESCRIPTION. An
    # optional block will be used for any validation or further processing,
    # where OPTIONS are the options processed so far and their values,
    # PROCESSED are the values of the arguments processed so far, and ARGUMENT
    # is the parsed value itself.
    # @param (see Method::Undefined#splus)
    # @yield (see Method::Undefined#splus)
    # @yieldparam (see Method::Undefined#splus)
    # @raise (see Method::Undefined#splus)
    # @return [self]
    # @example A Splus Argument
    #   class Git::CLI::Git::CheckAttr < Ame::Class
    #     splat 'PATHNAME', String, 'Files to list attributes of'
    #   end
    def splus(name, type, description, &validate)
      method.splus name, type, description, &validate
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # Sets up a dispatch method to KLASS.  A dispatch method delegates
    # processing to another class based on the first argument passed to it.
    # This is useful if you want to support sub-commands in a simple manner.
    # The description of KLASS will be used as the description of the dispatch
    # method.
    # @param [::Class] klass
    # @param [Hash<String, Object>] options
    # @option options [String] :default The default method to run; if given,
    #   method argument will be optional
    # @raise [ArgumentError] If any arguments have been defined on the method
    # @return [self]
    # @example A Git-like Command-line Interface
    #   class Git::CLI::Git < Ame::Class
    #     description 'The stupid content tracker'
    #     def initialize; end
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
        optional 'method', options[:default], 'Method to run'
      else
        argument 'method', String, 'Method to run'
      end
      splat 'arguments', String, 'Arguments to pass to METHOD'
      define_method Ame::Method.ruby_name(klass.basename) do |method, arguments|
        klass.process method, arguments
      end
      self
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end

    # @api developer
    # @return [Method::Undefined] The undefined method about to be defined
    def method
      @method ||= Ame::Method::Undefined.new(self)
    end

    protected

    # @api developer
    # @return [Class] The parent of the receiver
    attr_accessor :parent

    public

    # Sets the HELP object to use for displaying usage information, or returns
    # it if HELP is nil.  The default is to delegate the request to the
    # {.parent}.
    # @api developer
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
    # @api developer
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

    # @api developer
    # @return [String] The full name of the space-separated concatenation of
    #   the basenames of the receiver and its {.parent}s
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

    # @api developer
    # @return [Methods] The methods defined on the receiver
    def methods
      @methods ||= Ame::Methods.new
    end

    private

    # Defines the previously undefined {.method} now that it’s been added to
    # the class.
    # @api internal
    # @param [Symbol] ruby_name
    # @raise [ArgumentError] If RUBY_NAME is the name of a non-public method
    #   that’s being defined
    # @return [self]
    def method_added(ruby_name)
      if ruby_name == :initialize
        @description = method.define(ruby_name).description
      elsif public_method_defined? ruby_name
        methods << method.define(ruby_name)
      elsif method.valid?
        raise ArgumentError, 'non-public method cannot be used by Ame: %s' % ruby_name, caller
      end
      @method = nil
      self
    end
  end
end
