# -*- coding: utf-8 -*-

require 'lookout'
require 'stringio'

require 'ame'

Expectations do
  expect %{Usage: help-console-test-1 dispatch [OPTIONS]... METHOD [ARGUMENTS]...
  Dispatch description

Arguments:
  METHOD          Method to run
  [ARGUMENTS]...  Arguments to pass to METHOD

Options:
      --help  Display help for this method

Methods:
  method-1  Method 1 does a
  method-2  Method 2 does b
} do
    Ame::Class.stubs(:inherited)
    c = Class.new(Ame::Class) {
      include Singleton
      namespace 'help-console-test-1'

      description 'Root description'
      def initialize() end
    }
    c.stubs(:inherited)
    d = Class.new(c){
      stubs 'name' => 'HelpConsoleTest1::Dispatch'
      description 'Dispatch description'
      def initialize() end

      description 'Method 1 does a'
      def method_1() end

      description 'Method 2 does b'
      def method_2() end
    }
    Ame::Dispatch.new(Ame::Class, c).define
    Ame::Dispatch.new(c, d).define
    io = StringIO.new
    Ame::Class.help = Ame::Help::Console.new(io)
    Ame::Class.instance.process :'help-console-test-1', %w(dispatch --help)
    io.rewind
    io.read
  end

  expect %{Usage: namespace method [OPTIONS]... ARG1 ARG2 ARGN...
  Method description

Arguments:
  ARG1     Argument 1
  ARG2     Argument 2
  ARGN...  Argument N

Options:
  -a, --abc=ABC  Abc description
      --help     Display help for this method
  -v             V description
  -x=LEVEL       X description
} do
    Ame::Class.stubs(:inherited)
    c = Class.new(Ame::Class) {
      include Singleton
      namespace 'namespace'

      description 'Method description'
      option 'abc', 'Abc description', :aliases => 'a', :type => String
      option 'v', 'V description'
      option 'x', 'X description', :type => String, :argument => 'level'
      argument 'ARG1', 'Argument 1'
      argument 'ARG2', 'Argument 2'
      splat 'ARGN', 'Argument N'
      def method() end
    }
    io = StringIO.new
    Ame::Class.help = Ame::Help::Console.new(io)
    c.instance.process :method, %w(--help)
    io.rewind
    io.read
  end

  expect %{namespace 0.1.0\n} do
    c = Class.new(Ame::Class) {
      namespace 'namespace'

      Version = '0.1.0'

      description 'd'
      def initialize() end
    }
    io = StringIO.new
    Ame::Class.help = Ame::Help::Console.new(io)
    Ame::Class.instance.process :namespace, %w(--version)
    io.rewind
    io.read
  end
end
