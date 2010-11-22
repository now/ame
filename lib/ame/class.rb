# -*- coding: utf-8 -*-

class Ame::Class
  def process(name, arguments = [])
    catch Ame::AbortProcessing do
      self.class.methods[name].process self, arguments
    end
    self
  end

  def call(name, arguments = nil, options = nil)
    catch Ame::AbortProcessing do
      self.class.methods[name].call self, arguments, options
    end
    self
  end

  class << self
    extend Forwardable

    def basename(basename = nil)
      @basename = basename if basename
      return @basename if defined? @basename
      name.split('::').last.scan(/[[:upper:]][[:lower:]]+/).join('-').downcase
    end

    def fullname
      [].tap{ |names|
        klass = self
        until klass.nil? or klass.basename.empty?
          names << klass.basename
          klass = klass.parent
        end
      }.reverse.join(' ')
    end

    def description(description = nil)
      return method.description(description) if description
      defined?(@description) ? @description : ''
    end

    # TODO: Move to Ame::Root.
    def help=(help)
      @@help = help
    end

    def help_for_dispatch(method, subclass)
      help.for_dispatch self, method, subclass
    end

    def help_for_method(method)
      help.for_method self, method
    end

    def methods
      @methods ||= Ame::Methods.new
    end

    def dispatch(klass)
      klass.parent = self
      description klass.description
      options_must_precede_arguments
      dispatch = method
      option 'help', 'Display help for this method' do
        help_for_dispatch dispatch, klass
        throw Ame::AbortAllProcessing
      end unless method.options.include? 'help'
      method.arguments.arity.zero? or
        raise ArgumentError,
          'arguments may not be defined for a dispatch: %s' % klass
      argument 'method', 'Method to run'
      splat 'arguments', 'Arguments to pass to METHOD', :optional => true
      define_method Ame::Method.ruby_name(klass.basename) do |method, arguments, options|
        klass.new.process method, arguments
      end
    end

  protected

    attr_accessor :parent

  private

    def help
      @@help ||= Ame::Help::Console.new
    end

    def method
      @method ||= Ame::Method.new(self)
    end

    def method_added(name)
      if name == :initialize
        method.validate
        @description = method.description
      elsif [:process, :call].include? name
        (method.validate rescue false) and
          raise ArgumentError, '%s is a method name reserved by Ame' % name
      elsif public_instance_methods.map{ |m| m.to_sym }.include? name
        method.name = name
        methods << method if method.validate
      elsif (method.validate rescue false)
        raise ArgumentError, 'non-public method cannot be used by Ame: %s' % name
      end
      @method = Ame::Method.new(self)
    end

    def_delegators :method, :options_must_precede_arguments, :option, :argument, :splat
  end
end
