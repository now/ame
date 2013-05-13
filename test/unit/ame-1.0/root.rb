# -*- coding: utf-8 -*-

Expectations do
  expect Ame::Help::Console.new.to.receive.for_dispatch(:method, :subclass) do |o|
    Class.new(Ame::Root){
      help o
    }.help_for_dispatch :method, :subclass
  end

  expect Ame::Help::Console.new.to.receive.for_method(:method) do |o|
    Class.new(Ame::Root){
      help o
    }.help_for_method :method
  end
end
