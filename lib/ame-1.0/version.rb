# -*- coding: utf-8 -*-

require 'inventory-1.0'

module Ame
  Version = Inventory.new(1, 0, 0){
    def dependencies
      super + Inventory::Dependencies.new{
        development 'inventory-rake', 1, 4, 0
        development 'inventory-rake-tasks-yard', 1, 3, 0
        development 'lookout-rake', 3, 0, 0
        development 'yard', 0, 8, 0
        development 'yard-heuristics', 1, 1, 0
      }
    end

    def package_libs
      %w[argument.rb
         arguments.rb
         arguments/undefined.rb
         class.rb
         help.rb
         help/console.rb
         help/delegate.rb
         method.rb
         method/undefined.rb
         methods.rb
         option.rb
         options.rb
         options/undefined.rb
         root.rb
         splat.rb
         toggle.rb
         types.rb
         types/array.rb
         types/boolean.rb
         types/integer.rb
         types/string.rb]
    end
  }
end
