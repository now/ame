# -*- coding: utf-8 -*-

# Represents an option to a {Method} that takes an argument that can be given
# any number of times.  If an explicit (‘=’-separated) argument is given, it’ll
# be used, otherwise the following argument will be used.
# @api developer
class Ame::Multioption < Ame::Option
  # @api internal
  # @param (see Option#initialize)
  # @param [::Class] type
  # @yield (see Option#initialize)
  # @yieldparam (see Option#initialize)
  # @raise (see Flag#initialize)
  # @raise [ArgumentError] If TYPE isn’t one that Ame knows how to parse
  def initialize(short, long, argument, type, description, &validate)
    super short, long, argument, nil, description, &validate
    @type = Ame::Types[type]
    @ignored = true
  end

  # Invokes {super} and adds it to an Array added to OPTIONS before returning
  # it.
  # @api internal
  # @param (see Flag#process)
  # @raise (see Flag#process)
  # @return [Object]
  def process(options, arguments, name, explicit)
    @ignored = false
    (options[self.name] ||= []) << super
  end

  # @return True if the receiver hasn’t been asked to process any options yet
  def ignored?
    @ignored
  end
end
