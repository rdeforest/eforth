# Trying to build a Forth-like interpreter

Based on section 1 of http://www.exemark.com/FORTH/eForthOverviewv5.pdf and
stuff found at http://www.figuk.plus.com/4thres/systems.htm

# Aspects

## VM

The VM encapsulates the protocol which is 'normally' implemented in hardware.
It implements the processor, memory, I/O, etc., of a physical computer.
Version 1 will be CoffeeScript/JavaScript. Version 2 will be WebAssembly.

### CPU

Simulating the CPU is the most complex problem. The eForth standard has
minimal expectations of the CPU, but those expectations have to be realized
perfectly. There is state, there are operations and there is memory, and all
have to work as assumed by the spec.

### Memory

Memory is essentially an ArrayBuffer in NodeJS. The complexity arises from the
various ways memory is accessed.

### I/O

Traditional I/O is the same as memory except that writing has real-world
side-effects and the outside world can change the result of a read.

# The plan

## Use cases

### Bootstrapping from source

```sh
    bin/create [options] path/to/workspace
    path/to/workspace/bin/start
```

#### bin/create

Options will be for overriding paths to definitions and libraries.

#### $workspace/bin/start

Starts or resumes a session.

## Workspace layout

- bin/start
- lib/
  - immutable base (VM, 31 primitives)
- memory/
  - files

