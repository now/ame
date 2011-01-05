# -*- coding: utf-8 -*-

Expectations do
  expect output(%{Usage: help-console-test-1 [OPTIONS]... ARG1 ARG2 ARGN...
  Method description

Arguments:
  ARG1     Argument 1
  ARG2     Argument 2
  ARGN...  Argument N

Options:
  -a, --abc=ABC  Abc description
      --help     Display help for this method
  -v             V description
      --version  Display version information
  -x=LEVEL       X description
}) do |io|
    Class.new(Ame::Root) {
      help Ame::Help::Console.new(io, false)

      description 'Method description'
      option 'abc', 'Abc description', :aliases => 'a', :type => String
      option 'v', 'V description'
      option 'x', 'X description', :type => String, :argument => 'level'
      argument 'ARG1', 'Argument 1'
      argument 'ARG2', 'Argument 2'
      splat 'ARGN', 'Argument N'
      def help_console_test_1() end
    }.process('help-console-test-1', %w[--help])
  end

  expect output(%{Usage: dispatch [OPTIONS]... METHOD [ARGUMENTS]...
  Dispatch description

Arguments:
  METHOD          Method to run
  [ARGUMENTS]...  Arguments to pass to METHOD

Options:
      --help     Display help for this method
      --version  Display version information

Methods:
  method-1  Method 1 does a
  method-2  Method 2 does b
}) do |io|
    Class.new(Ame::Root) {
      help Ame::Help::Console.new(io, false)

      dispatch Class.new(Ame::Class) {
        basename 'dispatch'

        description 'Dispatch description'
        def initialize() end

        description 'Method 1 does a'
        def method_1() end

        description 'Method 2 does b'
        def method_2() end
      }
    }.process('dispatch', %w[--help])
  end

  expect output(%{Usage: dispatch-1 dispatch-2 [OPTIONS]... METHOD [ARGUMENTS]...
  Dispatch 2 description

Arguments:
  METHOD          Method to run
  [ARGUMENTS]...  Arguments to pass to METHOD

Options:
      --help  Display help for this method

Methods:
  method-1  Method 1 does a
  method-2  Method 2 does b
}) do |io|
    Class.new(Ame::Root) {
      help Ame::Help::Console.new(io, false)

      dispatch Class.new(Ame::Class) {
        basename 'dispatch-1'

        description 'Dispatch 1 description'
        def initialize() end

        dispatch Class.new(Ame::Class) {
          basename 'dispatch-2'

          description 'Dispatch 2 description'
          def initialize() end

          description 'Method 1 does a'
          def method_1() end

          description 'Method 2 does b'
          def method_2() end
        }
      }
    }.process('dispatch-1', %w[dispatch-2 --help])
  end

  expect output(%{Usage: dispatch [OPTIONS]... [METHOD] [ARGUMENTS]...
  Dispatch description

Arguments:
  [METHOD=method-1]  Method to run
  [ARGUMENTS]...     Arguments to pass to METHOD

Options:
      --help     Display help for this method
      --version  Display version information

Methods:
  method-1  Method 1 does a
  method-2  Method 2 does b
}) do |io|
    Class.new(Ame::Root) {
      help Ame::Help::Console.new(io, false)

      dispatch Class.new(Ame::Class) {
        basename 'dispatch'

        description 'Dispatch description'
        def initialize() end

        description 'Method 1 does a'
        def method_1() end

        description 'Method 2 does b'
        def method_2() end
      }, :default => 'method-1'
    }.process('dispatch', %w[--help])
  end

  expect output(%{method 0.1.0\n}) do |io|
    Class.new(Ame::Root) {
      Version = '0.1.0'

      help Ame::Help::Console.new(io)

      description 'd'
      def method() end
    }.process 'method', %w[--version]
  end

  expect output("method: error message\n") do |io|
    begin
      Class.new(Ame::Root) {
        help Ame::Help::Console.new(io, false)

        description 'd'
        def method()
          raise 'error message'
        end
      }.process 'method', []
    rescue RuntimeError => e
      raise unless e.message == 'error message'
    end
  end
end
