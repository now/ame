# -*- coding: utf-8 -*-

require 'singleton'

class Ame::Class
  extend Ame::Base::ClassMethods
  include Ame::Base
  include Singleton

  def self.namespace(options = {})
    @description = options[:description] if options[:description]
    @namespace = options[:name] if options.member? :name
    @namespace = name.gsub('::', ':').downcase if @namespace.nil? or @namespace.empty?
    @namespace
  end

  def self.description(description = nil)
    return super if description
    @description
  end

private

  def self.inherited(subclass)
    Ame::Classes << subclass
  end
end
