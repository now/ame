# -*- coding: utf-8 -*-

Expectations do
  expect ArgumentError.new('option already defined: a') do
    Ame::Options::Undefined.new.option(:a, 'd').option(:a, 'd')
  end

  expect result.include? 'a' do Ame::Options::Undefined.new.option(:a, 'd') end
  expect result.include? :a do Ame::Options::Undefined.new.option(:a, 'd') end
end
