# -*- coding: utf-8 -*-

Expectations do
  expect ArgumentError.new('option already defined: a') do
    Ame::Options::Undefined.new.flag('a', '', false, 'd').flag('a', '', false, 'd')
  end

  expect result.include? 'a' do Ame::Options::Undefined.new.flag('a', '', false, 'd') end
  expect result.include? :a do Ame::Options::Undefined.new.flag('a', '', false, 'd') end
end
