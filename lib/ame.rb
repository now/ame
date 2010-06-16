# -*- coding: utf-8 -*-

require 'forwardable'

module Ame
  Error = Class.new(StandardError)
  MalformedArgument = Class.new(Error)
  MissingArgument = Class.new(Error)
  SuperfluousArgument = Class.new(Error)
  UnrecognizedOption = Class.new(Error)

  autoload :Argument, 'ame/argument'
  autoload :Arguments, 'ame/arguments'
  autoload :Class, 'ame/class'
  autoload :Dispatch, 'ame/dispatch'
  autoload :Help, 'ame/help'
  autoload :Method, 'ame/method'
  autoload :Methods, 'ame/methods'
  autoload :Option, 'ame/option'
  autoload :Options, 'ame/options'
  autoload :Splat, 'ame/splat'
  autoload :Types, 'ame/types'
  autoload :Version, 'ame/version'
end
