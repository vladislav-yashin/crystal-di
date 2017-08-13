require "./spec_helper"

describe DI::AutoInject do
  it "injects type-hinted items" do
    Bar.new.foo.class.should eq(InjectedFoo)
  end

  it "injects context item" do
    Bar.new.context_foo.class.should eq(ContextFoo)
  end
end
