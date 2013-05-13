# -*- coding: utf-8 -*-

Expectations do
  expect Ame::Help::Console.new.to.receive.dispatch(:method, :subclass) do |o|
    Class.new(Ame::Root){
      help o
    }.help.dispatch :method, :subclass
  end

  expect Ame::Help::Console.new.to.receive.method(:method) do |o|
    Class.new(Ame::Root){
      help o
    }.help.method :method
  end
end
