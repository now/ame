# -*- coding: utf-8 -*-

Expectations do
  expect Ame::MissingArgument do Ame::Splat.new('a', 'd').process({}, [], []) end

  expect [] do Ame::Splat.new('a', 'd', :optional => true).process({}, [], []) end
  expect ['arg'] do Ame::Splat.new('a', 'd').process({}, [], %w[arg]) end
  expect [1, 2] do Ame::Splat.new('a', 'd', :type => Integer).process({}, [], %w[1 2]) end
end
