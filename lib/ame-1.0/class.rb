# -*- coding: utf-8 -*-

class Ame::Class
  class << self
    def basename(basename = nil)
      @basename = basename if basename
      return @basename if defined? @basename
      name.split('::').last.scan(/[[:upper:]][[:lower:]]*/).join('-').downcase
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

    def help_for_dispatch(method, subclass)
      parent.help_for_dispatch(method, subclass)
    end

    def help_for_method(method)
      parent.help_for_method(method)
    end

    def methods
      @methods ||= Ame::Methods.new
    end

    def dispatch(klass, options = {})
      klass.parent = self
      description klass.description
      options_must_precede_arguments
      dispatch = method
      option :help, 'Display help for this method', :ignore => true do
        help_for_dispatch dispatch, klass
        throw Ame::AbortAllProcessing
      end unless method.options.include? :help
      method.arguments.arity.zero? or
        raise ArgumentError,
          'arguments may not be defined for a dispatch: %s' % klass
      argument :method, 'Method to run', options.include?(:default) ?
        {:optional => true, :default => options[:default]} :
        {}
      splat :arguments, 'Arguments to pass to METHOD', :optional => true
      define_method Ame::Method.ruby_name(klass.basename) do |method, arguments|
        klass.new.process method, arguments
      end
    end

  protected

    attr_accessor :parent

  private

    def options_must_precede_arguments
      method.options_must_precede_arguments
      self
    end

    def option(name, description, options = {}, &validate)
      method.option name, description, options, &validate
      self
    end

    def argument(name, description, options = {}, &validate)
      method.argument name, description, options, &validate
      self
    end

    def splat(name, description, options = {}, &validate)
      method.splat name, description, options, &validate
      self
    end

    def method
      @method ||= Ame::Method.new(self)
    end
  end

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
    private

    def method_added(name)
      if name == :initialize
        @description = method.define(name).description
      elsif [:process, :call].include? name
        method.valid? and
          raise NameError, 'method name reserved by Ame: %s' % name
      elsif public_method_defined? name
        methods << method.define(name)
      elsif method.valid?
        raise ArgumentError, 'non-public method cannot be used by Ame: %s' % name
      end
      @method = Ame::Method.new(self)
    end
  end
end
