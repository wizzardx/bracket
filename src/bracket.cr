# Implements the bracket pattern for safe resource management in Crystal.
#
# The bracket pattern ensures that resources are properly initialized and cleaned up,
# similar to Python's context managers or Haskell's bracket pattern.
module Bracket
  VERSION = "0.1.0"

  # Manages a resource's lifecycle using setup and teardown functions.
  #
  # This method:
  # 1. Calls the setup function to initialize the resource
  # 2. Yields the resource to the provided block
  # 3. Ensures the teardown function is called even if an exception occurs
  #
  # ## Type Parameters
  # * T : The type of the resource being managed
  #
  # ## Parameters
  # * setup : A function that creates and returns the resource
  # * teardown : A function that cleans up the resource
  #
  # ## Examples
  #
  # ```
  # # Managing a simple string resource
  # setup = -> { "my resource" }
  # teardown = ->(resource : String) { puts "Cleaning up"; nil }
  #
  # Bracket.with_resource(setup, teardown) do |resource|
  #   puts "Using #{resource}"
  # end
  # ```
  def self.with_resource(setup : -> T, teardown : T -> Nil) forall T
    resource = setup.call
    begin
      yield resource
    ensure
      teardown.call(resource)
    end
  end
end
