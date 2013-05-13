# -*- coding: utf-8 -*-

module Ame
  AbortAllProcessing = :AmeAbortAllProcessing
  AbortProcessing = :AmeAbortProcessing

  Error = Class.new(StandardError)
  UnrecognizedMethod = Class.new(Error)
  MalformedArgument = Class.new(Error)
  MissingArgument = Class.new(Error)
  SuperfluousArgument = Class.new(Error)
  UnrecognizedOption = Class.new(Error)

  load File.expand_path('../ame-1.0/version.rb', __FILE__)
  Version.load
end
