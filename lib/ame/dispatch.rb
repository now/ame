# -*- coding: utf-8 -*-

class Ame::Dispatch < Ame::Method
  def initialize(klass, subclass)
    super klass
    @subclass = subclass
  end

  def define
    # TODO: We really need a gensym here.
    __sAD = @subclass
    @class.instance_eval do
      description __sAD.description
      options_must_precede_arguments
      option 'version', 'display version information' if self == Ame::Class
      argument 'method', 'method to run'
      splat 'arguments', 'arguments to pass to METHOD', :optional => true
      define_method __sAD.namespace.split(' ').last do |method, arguments, options|
        if options['version']
          # Ame::Help::Console.version(self) # ⇒ puts klass.const_get('Version')
        else
          __sAD.instance.process method, arguments
        end
      end
    end
  end

private

  def help
    @class.help_for_dispatch self, @subclass
  end
end
