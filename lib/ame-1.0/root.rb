# -*- coding: utf-8 -*-

# Root of a hierarchy of {Class}es.  This class should be subclassed by the
# root of your command-line interface.
# @example An rm-like Command-line Interface with Ame
#   class Rm < Ame::Root
#     version '1.0.0'
#
#     flag 'f', '', false, 'Do not prompt for confirmation'
#     flag 'i', '', nil, 'Prompt for confirmation' do |options|
#       options['f'] = false
#     end
#     flag 'R', '', false, 'Remove file hierarchies'
#     flag 'r', '', nil, 'Equivalent to -R' do |options|
#       options['r'] = true
#     end
#     splus 'FILE', String, 'File to remove'
#     description 'Remove directory entries'
#     def rm(first, *rest)
#       options = rest.pop
#       require 'fileutils'
#       FileUtils.send options['R'] ? :rm_r : :rm,
#         [first] + rest, :force => options['f']
#     end
#   end
#   Rm.process
# @example A Git-like Command-line Interface With Ame
#   class Git::CLI < Ame::Root
#     version '1.0.0'
#     dispatch Git
#   end
#   class Git::CLI::Git < Ame::Class
#     description 'The stupid content tracker'
#     def initialize; end
#
#     description 'Show various types of objects'
#     option :'abbrev-commit', 'Show only partial prefix'
#     splat :objects, 'The names of objects to show'
#     def show(*objects)
#       options = objects.pop
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
class Ame::Root < Ame::Class
  class << self
    # Sets the HELP object to use for displaying usage information, or returns
    # it if HELP is nil.  The default is to use a {Help::Console} object.
    # @param (see Class.help)
    # @return [#method, #dispatch, #error, #version]
    def help(help = nil)
      super if help
      @help ||= Ame::Help::Console.new
    end

    # Sets or returns, depending on if VERSION is nil or not, the version of
    # the receiver.  The version may be used by {.help} to output version
    # information.
    # @param [String, nil] version
    # @return [String]
    def version(version = nil)
      return @version = version if version
      @version
    end

    # Process ARGUMENTS as a list of options and arguments, then call METHOD
    # with the results of this processing on a new instance of the receiver.
    # This method catches {AbortAllProcessing}.  Any errors will be caught and
    # reported using {.help}#error.
    # @param (see Class.process)
    # @return [self]
    def process(method = File.basename($0), arguments = ARGV)
      catch Ame::AbortAllProcessing do
        super
      end
      self
    rescue => e
      help.error method, e
    end

    # Call METHOD with ARGUMENTS and OPTIONS on a new instance of the receiver.
    # This method catches {AbortAllProcessing}.
    # @param (see Class.call)
    # @raise (see Class.call)
    # @return [self]
    def call(method, arguments = nil, options = nil)
      catch Ame::AbortAllProcessing do
        super
      end
      self
    end

    # @api developer
    # @return [String] An empty string
    def basename
      ''
    end

    private

    # Defines the previously undefined {.method} now that it’s been added to
    # the class after adding flag “version” that’ll call {.help}#version to
    # output version information and then throw {AbortAllProcessing}.
    # @api internal
    # @param (see Class.method_added)
    # @raise (see Class.method_added)
    # @raise [ArgumentError] If {.version} hasn’t been set
    # @return [self]
    def method_added(ruby_name)
      unless method.option? 'version'
        raise ArgumentError, 'version not set, set it with version VERSION', caller unless defined? @version
        flag '', 'version', nil, 'Display version information' do
          help.version methods[Ame::Method.name(ruby_name)], self.version
          throw Ame::AbortAllProcessing
        end
      end
      super
    rescue; $!.set_backtrace(caller[1..-1]); raise
    end
  end
end
