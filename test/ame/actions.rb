# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect Enumerable do
    Ame::Actions.new
  end

=begin
  expect Ame::Action.new do |action|
    Ame::Actions.new << action
  end
=end
end
