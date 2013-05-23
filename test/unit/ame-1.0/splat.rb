# -*- coding: utf-8 -*-

Expectations do
  expect Ame::MissingArgument do Ame::Splus.new('a', String, 'd').process({}, [], []) end

  expect [] do Ame::Splat.new('a', String, 'd').process({}, [], []) end
  expect ['arg'] do Ame::Splat.new('a', String, 'd').process({}, [], %w[arg]) end
  expect [1, 2] do Ame::Splat.new('a', Integer, 'd').process({}, [], %w[1 2]) end
end
