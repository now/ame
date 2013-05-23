# -*- coding: utf-8 -*-

Expectations do
  expect output(%{Usage: help-console-test-1 [OPTIONS]... ARG1 ARG2 ARGN...
  Method description

Arguments:
  ARG1     Argument 1
  ARG2     Argument 2
  ARGN...  Argument N

Options:
  -a, --abc=ABC         Abc description
      --help            Display help for this method
  -s, --signoff         Add Signed-off-by: line to the commit message
      --thread[=STYLE]  Controls addition of In-Reply-To and References headers
  -v                    V description
      --version         Display version information
  -xLEVEL               X description
}) do |io|
    Class.new(Ame::Root) {
      help Ame::Help::Console.new(io, io, false)

      description 'Method description'
      option 'a', 'abc', 'abc', '', 'Abc description'
      flag   'v', '', false, 'V description'
      toggle ?s, 'signoff', false, 'Add Signed-off-by: line to the commit message'
      switch '', 'thread', 'style', nil, :shallow, 'Controls addition of In-Reply-To and References headers'
      option 'x', '', 'level', '', 'X description'
      argument :arg1, String, 'Argument 1'
      argument :arg2, String, 'Argument 2'
      splus :argN, String, 'Argument N'
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
      help Ame::Help::Console.new(io, io, false)

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
      help Ame::Help::Console.new(io, io, false)

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
      help Ame::Help::Console.new(io, io, false)

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
      version '0.1.0'

      help Ame::Help::Console.new(io, io)

      description 'd'
      def method() end
    }.process 'method', %w[--version]
  end

  expect output("method: error message\n") do |io|
    begin
      Class.new(Ame::Root) {
        help Ame::Help::Console.new(io, io, false)

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
