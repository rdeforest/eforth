# Just thinking out loud

- What makes a programming syntax good?
 - Unambiguous
 - Familiar
  - depends on individual experience
 - Succinct
 - Consistent

- What are the fundamental statements?
 - Interfaces
  - Structures/Shapes
   - Concatonation (array of...)
   - Composition (struct of...)
   - Extension (like parent but also...)
  - Interface definitions/contracts
   - What to expect when you're expecting a callback :)
 - Implementations - "When this contract is invoked, this is a way to satisfy it..."
  - Map
   - Transform - "turn strings into their lengths"
   - Associate - "turn strings into objects with matching names"
  - Reduce
   - Combine   - sum, concat
   - Summarize - count, group
  - Alias?
   - typedefs, constants, etc
   - actually a kind of map, but for code
  - I/O

- What are some smaller concepts a language represents?
 - Literal values (numbers, strings, sets...)
 - Operations (messages)
 - Quoted code
 - Capture of execution contexts
 - templates (string interpolation, macros...)
 - patterns (regexps, globs, code patterns...)

# Surprises

Dictionaries/hashes/objects are a map from keys to values

Conditionals map true/false values to expressions

    myIf = (pred, yep, nope) ->
      {true: yep, false: nope}[pred]

I can't think of a reason to have a while true loop any more. The Node engine
already provides one in the form of the event loop. Waiting can be
accomplished with callbacks, timers and events. An Amiga bouncing-ball app
could be implemented with setInterval for the updates. Lazily yielded
sequences can be accomplished with recursion:

    fib = (prev2 = 0, prev = 1) ->
      yield cur = prev2 + prev
      yield from fib prev, cur

    for f from fib 0, 1
      if f > 10
        break
      f

> [ 1, 2, 3, 5, 8 ]

Though in Node v7.10.0 and CoffeeScript 1.12.4, yield from doesn't optimize
for tail recursion, so there actually is a limit on this form of iteration.

# Is there something wrong with CoffeeScript?

Maybe not? If we're concerned about performance we could probably compile it
