# Pros

## Dynamic

## Takes "everything is an object" _all the way_

```st

    1 print      "equialent to 1.print() in ECMAScript"
    x := [ 123 ] "kinda like x = -> in CoffeeScript"
    x inspect    "Yields something like:"

    "An instance of BlockClosure"
    "  outerContext: nil"
    "  block: [] in UndefinedObject>>executeStatements"
    "  receiver: UndefinedObject"
    "a BlockClosure"

```

## Smart run-time library

Discoverability is a priority.

Classes have comments on them.

```st

    [ ] class comment "Yields..."

    "I am a factotum class.  My instances represent Smalltalk blocks, portions
    of executeable code that have access to the environment that they were
    declared in, take parameters, and can be passed around as objects to be
    executed by methods outside the current class.
    Block closures are sent a message to compute their value and create a new
    execution context; this property can be used in the construction of
    control flow methods.  They also provide some methods that are used in the
    creation of Processes from blocks."

```

# Cons

## Syntax

Not a deal breaker, but it's archaic, and the only syntaxtic sugar is the
operators.

## Not doing anything I can't do elsewhere

The only languages I know of which can easily do things that are hard in
others are Lisp and FORTH. Lisp leaves its code in AST form, FORTH has direct
hardware access while still being a relatively high-level language.

# Hm...

I haven't _yet_ figured out how to use it for scripting or for apps.
