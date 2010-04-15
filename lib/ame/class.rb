# -*- coding: utf-8 -*-

require 'singleton'

class Ame::Class
  extend Ame::Base::ClassMethods
  include Ame::Base
  include Singleton

  def self.namespace(namespace = nil)
    return @namespace = namespace if namespace
    @namespace = name.gsub('::', ':').downcase if @namespace.nil? or @namespace.empty?
    @namespace
  end

private

  def self.inherited(subclass)
    Ame::Classes << subclass
  end
end
