require "./spec_helper"

describe Bracket do
  it "manages resource lifecycle" do
    setup_called = false
    teardown_called = false
    resource_value = "test"

    setup = -> {
      setup_called = true
      resource_value
    }

    teardown = ->(r : String) {
      teardown_called = true
      nil
    }

    result = Bracket.with_resource(setup, teardown) do |r|
      r.should eq(resource_value)
      "processed"
    end

    result.should eq("processed")
    setup_called.should be_true
    teardown_called.should be_true
  end

  it "ensures teardown runs even when an exception occurs" do
    teardown_called = false

    setup = -> { "test" }
    teardown = ->(r : String) {
      teardown_called = true
      nil
    }

    expect_raises(Exception, "test error") do
      Bracket.with_resource(setup, teardown) do |r|
        raise "test error"
      end
    end

    teardown_called.should be_true
  end

  it "works with different resource types" do
    setup = -> { {name: "test", value: 42} }
    teardown = ->(r : NamedTuple(name: String, value: Int32)) { nil }

    Bracket.with_resource(setup, teardown) do |r|
      r[:name].should eq("test")
      r[:value].should eq(42)
    end
  end
end
