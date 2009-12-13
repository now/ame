# -*- coding: utf-8 -*-

require 'optparse'
require 'ostruct'

class Ame; end

class Ame::Context
  def initialize
    @optionsparser = OptionsParser.new
    @options = OpenStruct.new
    @arguments = Ame::Arguments.new
  end
end
