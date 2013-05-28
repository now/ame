# -*- coding: utf-8 -*-

# Namespace for Ame.
# @api developer/user
module Ame
  # Value thrown to abort processing of a {Root.process} or {Root.call}.
  AbortAllProcessing = :AmeAbortAllProcessing

  # Value thrown to abort processing of a {Class.process} or {Class.call}.
  AbortProcessing = :AmeAbortProcessing

  Error = Class.new(StandardError)

  # Error raised when a dispatch is invoked on a method that doesn’t exist.
  UnrecognizedMethod = Class.new(Error)

  # Error raised when an argument can’t be parsed into the desired type.
  MalformedArgument = Class.new(Error)

  # Error raised when a required argument is missing.
  MissingArgument = Class.new(Error)

  # Error raised when too many arguments have been given.
  SuperfluousArgument = Class.new(Error)

  # Error raised when an unrecognized option has been given.
  UnrecognizedOption = Class.new(Error)

  load File.expand_path('../ame-1.0/version.rb', __FILE__)
  Version.load
end
