# -*- coding: utf-8 -*-

Expectations do
  expect Ame::Method do
    Ame::Dispatch.new(nil, nil)
  end

  expect mock.to.receive.class_exec do |o|
    Ame::Dispatch.new(o, nil).define
  end

=begin
  expect Ame::Class.to.receive.description('d') do
    Ame::Class.stubs :options_must_precede_arguments
    Ame::Class.stubs :option
    Ame::Class.stubs :argument
    Ame::Class.stubs :splat
    Ame::Class.stubs :define_method
    Ame::Dispatch.new(Ame::Class, stub(:description => 'd', :namespace => 'a')).define
  end

  expect Ame::Class.to.receive(:options_must_precede_arguments) do
    Ame::Class.stubs :description
    Ame::Class.stubs :option
    Ame::Class.stubs :argument
    Ame::Class.stubs :splat
    Ame::Class.stubs :define_method
    Ame::Dispatch.new(Ame::Class, stub(:description => 'd', :namespace => 'a')).define
  end

  expect Ame::Class.to.receive(:option).with('version', instance_of(String)) do
    Ame::Class.stubs :description
    Ame::Class.stubs :options_must_precede_arguments
    Ame::Class.stubs :argument
    Ame::Class.stubs :splat
    Ame::Class.stubs :define_method
    Ame::Dispatch.new(Ame::Class, stub(:description => 'd', :namespace => 'a')).define
  end

  expect Ame::Class.to.receive(:argument) do
    Ame::Class.stubs :description
    Ame::Class.stubs :options_must_precede_arguments
    Ame::Class.stubs :option
    Ame::Class.stubs :splat
    Ame::Class.stubs :define_method
    Ame::Dispatch.new(Ame::Class, stub(:description => 'd', :namespace => 'a')).define
  end

  expect Ame::Class.to.receive(:splat).with(instance_of(String), instance_of(String), has_entry(:optional => true)) do
    Ame::Class.stubs :description
    Ame::Class.stubs :options_must_precede_arguments
    Ame::Class.stubs :option
    Ame::Class.stubs :argument
    Ame::Class.stubs :define_method
    Ame::Dispatch.new(Ame::Class, stub(:description => 'd', :namespace => 'a')).define
  end

  expect Ame::Class.to.receive(:define_method).with('b') do
    Ame::Class.stubs :description
    Ame::Class.stubs :options_must_precede_arguments
    Ame::Class.stubs :option
    Ame::Class.stubs :argument
    Ame::Class.stubs :splat
    Ame::Dispatch.new(Ame::Class, stub(:description => 'd', :namespace => 'a b')).define
  end

  expect Ame::Class.to.receive.help_for_dispatch(Ame::Dispatch, :subclass) do |o|
    catch Ame::AbortAllProcessing do
      Ame::Dispatch.new(o, :subclass).description('d').validate.process o, ['--help']
    end
  end
=end
end
