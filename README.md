# bracket

A Crystal shard that implements the bracket pattern for safe resource management. This pattern ensures that resources are properly initialized and cleaned up, similar to Python's context managers or Haskell's bracket pattern.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     bracket:
       github: wizzardx/bracket
   ```

2. Run `shards install`

## Usage

```crystal
require "bracket"

# Simple example with a string resource
setup = -> { "my resource" }
teardown = ->(resource : String) { puts "Cleaning up #{resource}"; nil }

Bracket.with_resource(setup, teardown) do |resource|
  puts "Using #{resource}"
end

# Example with server resource
server_setup = -> {
  port = find_available_port
  server = start_server(port)
  {server, port}
}

server_teardown = ->(resource : Tuple(Server, Int32)) {
  server, port = resource
  server.stop
  nil
}

Bracket.with_resource(server_setup, server_teardown) do |resource|
  server, port = resource
  # Use server...
end
```

## Features

- Guarantees resource cleanup even if an exception occurs
- Type-safe resource handling
- Simple, functional interface
- Works with any resource type

## Development

Run tests:
```crystal
crystal spec
```

## Contributing

1. Fork it (<https://github.com/wizzardx/bracket/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [David Purdy](https://github.com/wizzardx) - creator and maintainer
