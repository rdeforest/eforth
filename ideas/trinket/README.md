# Trinkets

## What is it?

Tiny libraries equivalent to a single Lego piece.

## Why?

Because there are too many implementations of simple things tied together with
other things.

## How?

### Definitions

*Trinket*

A set of

- consumed interfaces such as
  - Trinket API version information
  - resources
  - other trinket interfaces
- provided interface(s)
  - How to consume the trinket's behavior(s)
  - behavior guidance (optional)
- implementation details
  - "run this code in that interpreter"

*Requirement*

An interface identifier and version:

  - trinket://trinket.thatsnice.org/trinket/base/v1
  - trinket://trinket.thatsnice.org/data/set/v1
  - trinket://trinket.thatsnice.org/transform/sort/v1

- The protocol defines a minimum "VM"-like platform which provides a common API
  for popular compute enginers (bare metal, VMs, interpreters, etc).

- Interface Specifications
 - Are versioned
 - Lower interfaces
  - the Trinket standard interfaces consumed by the specified trinket
  - other trinket interfaces (with version expectations) which must already be functional for this trinket to work
 - Upper interface is the trinket's promise to its consumers

# How is this better than existing package systems?

- It is language and platform independent.
- It favors micro-packages which
 - can be updated with minimal impact on other packages
 - a package update will always be entirely related to the package's purpose
 - therefore any given package will have fewer updates
 - blast radius reduced
 - multiple versions of the same package can co-exist
 - A consumer may consume multiple versions for testing and graceful transitions
 
# Proof of Concept

```coffee

    require 'trinket'
      .create module.exports,
        name: "HelloTrinket"
        domain: "trinket.thastnice.org"
        description: "The Hello World trinket"

        version: "1.0"
        parameters: ...

        dependencies:
          "trinket.thatsnice.org":
            Trinket:
              IO: streamWriter: "1.0"
              Value: "UTF-8 data": "1.0"

        instanceParamaters:
          stdout:
            required: true
            Trinket: IO: streamWriter: "1.0"
          greeting:
            default: "Hello world!"
            Trinket: Value: "UTF-8 data": "1.0"

        implementation: [
          { invoke: stdout: args: "greeting" }
        ]

```

To use HelloTrinket from another Trinket:

```coffee

    require 'trinket'
      .create module.exports,
        name: "ExampleTrinket"
        domain: "trinket.thastnice.org"
        description: "Example consumer of The Hello World trinket"
        version: "1.0"

        dependencies:
          "trinket.thatsnice.org":
            Trinket:
              sys: console: stdout: "1.0"
              HelloTrinket: "1.0"

        instanceConstants:
          hello:  Trinket: HelloTrinket: "1.0"
          stdout: Trinket: sys: console: stdout: "1.0"

        implementation: [
          { invoke: "hello" }
        ]

```

To use ExampleTrinket from the shell:

```

$ trinket ExampleTrinket
Hello world!
$

```

Or to invoke HelloTrinket:


```

$ trinket HelloTrinket \
  stdout: trinket://trinket.thatsnice.org/Trinket/sys/console/stdout/1.0 \
  greeting: "And a fine day to you as well, sir!"
And a fine day to you as well, sir!
$

```

The 'trinket' command will be the CLI tool for invoking trinkets.
