# -*- coding: utf-8 -*-

class Ame::Dispatch < Ame::Method
  def initialize(klass, subclass)
    super klass
    @subclass = subclass
  end

  def define
    @class.class_exec(@subclass, self) do |subclass, dispatch|
      @method = dispatch
      description subclass.description
      options_must_precede_arguments
      option 'version', 'Display version information' do
        help.version subclass
        throw Ame::AbortProcessing
      end if self == Ame::Class
      argument 'method', 'Method to run'
      splat 'arguments', 'Arguments to pass to METHOD', :optional => true
      define_method subclass.namespace.split(' ').last do |method, arguments, options|
        subclass.instance.process method, arguments
      end
    end
  end

private

  def help
    @class.help_for_dispatch self, @subclass
  end
end
