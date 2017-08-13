require "spec"
require "../src/di"

module Container
  include DI::ContainerMixin

  register Foo, Foo.new
  register BlockFoo do
    BlockFoo.new
  end
  register MemoFoo, MemoFoo.new, memoize: true
  register ContextFoo, ContextFoo.new, context: Bar
  register FooInterface, InjectedFoo.new
end

module FooInterface
end

class Foo
  include FooInterface
end

class BlockFoo
end

class MemoFoo
end

class ContextFoo
end

class InjectedFoo
  include FooInterface
end

class Bar
  include DI::AutoInject(Container)
  getter foo, context_foo

  def initialize(@foo : FooInterface, @context_foo : ContextFoo)
  end
end
