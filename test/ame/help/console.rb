# -*- coding: utf-8 -*-

require 'lookout'

require 'ame'

Expectations do
  expect %{Usage: root dispatch [OPTIONS] METHOD [ARGUMENTS]...
  Dispatch description

Arguments:
  METHOD          Method to run
  [ARGUMENTS]...  Arguments to pass to METHOD

Options:
      --help     Display help for this method
  
Methods:
  method1  Method 1 does a
  method2  Method 2 does b} do
    Ame::Class.stubs(:inherited)
    c = Class.new(Ame::Class) {
      include Singleton
      namespace 'root'

      description 'Root description'
      def initialize() end
    }
    c.stubs(:inherited)
    d = Class.new(c){
      stubs 'name' => 'Root::Dispatch'
      description 'Dispatch description'
      def initialize() end

      description 'Method 1 does a'
      def method1() end

      description 'Method 2 does b'
      def method2() end
    }
    Ame::Dispatch.new(Ame::Class, c).define
    Ame::Dispatch.new(c, d).define
    Ame::Class.instance.process :root, %w(dispatch --help)
  end

=begin
    m.description 'Method description'
    m.option 'abc', 'abc description', :aliases => 'a', :type => String
    m.option 'v', 'v description'
    m.argument 'A', 'A description'
    m.argument 'B', 'B description'
    m.splat 'C', 'C description'
    m.name = 'method'
    Ame::Help::Console.new.method(m)
  end
=end
end
