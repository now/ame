# -*- coding: utf-8 -*-

# An option to an Ame {Method}.
class Ame::Option < Ame::Switch
  def initialize(short, long, argument, default, description, &validate)
    super short, long, argument, default, nil, description, &validate
  end

  def process_combined(options, arguments, name, remainder)
    [process(options, arguments, name, remainder.empty? ? nil : remainder), '']
  end

  private

  def parse(arguments, explicit)
    @type.parse(explicit || arguments.shift || raise(Ame::MissingArgument, 'missing argument: %s' % self))
  end
end
