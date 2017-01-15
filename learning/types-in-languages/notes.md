# The Problem

I (Robert) disagree with very smart, experienced people about what sorts of
restrictions languages should place on programmers.

# Definitions

_If not specified here, I am probably using words the way they are used in
ECMAScript or Perl._

name        | description | examples
------------|-------------|---------
value       | a tuple of a type and a discrete unit of program state | 'hello', 0, 1, undefined, null, a reference to an object
type        | the definition of possible interactactions with a value
object      | a collection of state and functionality which receives messages which may alter the object's state when handled by a method
reference   | a value which receives messages for an object
function    | a mapping from zero or more values to one or more other values
procedure   | a function with side-effects and/or inputs not included in the parameters (I/O)
variable    | a named container of a value
member      | a variable contained within an object
message     | a name and zero or more arguments
method      | a function or procedure which handles messages
parameter   | a variable which takes on the value of an argument included in a message, function or procedure call
command     | a program used in a command shell or shell script
application | a program used via a graphical interface
service     | a program used via a network interface
compiler    | a program which converts human-written code into a program or library
library     | a collection of named static values, functions, procedures and classes
class       | an object template or constructor

# What I hear from others

## Type restrictions protect against programmer errors

I'm still not convinced of this. I believe they simply change the forms of the
errors. When a programmer writes code with containing a type conflict, the
error they made happened well before they wrote the code; it happened when
they designed their architecture, models and program flow.

## Type declarations improve readability

This may be true for me in some cases, but not often. In dynamic languages I
use descriptive variable names to accomplish the intended communication.

```c
    #include <stdio>

    void main(int argc, char** argv) {
      printf("You provided %d argument(s).\n", argc);
    }
```

```coffee
    {argv, stdout} = require 'process'

    # Declaring the type of argCount's value would be redundant since the name
    # implies a numeric value.
    argCount = argv.length
    console.log "You provided #{argCount} argument(s).\n"
```

## Type declarations create useful expressiveness

I believe this refers to (among other things) the ability to treat the types
of the arguments and return value of a procedure as part of the procedure's
name. In other words, two procedures may have the same name if their
"signature" differs.

```
    # Pseudo-code based on CoffeeScript, to be converted to a real language
    # later, probably TypeScript.
    class Vector extends Array
      constructor: (Integer length >= 0) ->
        super
        @[dim] = 0 for dim in [0..length - 1]

      copyFrom: (Vector(@length) v) ->
        for dim in [0..len - 1]
          @[dim] = v[dim]

      add: (Vector(@length) v) ->
        for dim in [0..len - 1]
          @[dim] += v[dim]

      multiplyBy: (Scalar n) ->
        for dim in [0..len - 1]
          @[dim] *= n

    class Location extends Vector
      move: (Location(@length) destination) -> @copyFrom destination
 
      move: (Vector(@length) path) -> @add path

      move: (Velocity v, Duration dt) ->
        path = new Vector @length
          .copyFrom v
          .multiplyBy dt

        @move path
```

The point as I understand it is that the move method can be extended to accept
or return new types without breaking its interface. I do not see this as a
good feature. I prefer method names to be unique.

```coffee
    class Location extends Vector
      moveTo: (destination) ->
        @copyFrom destination

      moveAlong: (path) ->
        @add path

      applyVelocity: (v, dt) ->
        path = new Vector @length
          .copyFrom v
          .multiplyBy dt

        @move path
```

There _is_ one feature of type annotation which I find useful. If it is
sufficiently expressive it makes good shorthand for input validation. Without
types Vector gets more verbose:

```coffee
    class Vector extends Array
      constructor: (length) ->
        unless length > 0 or length is 0
          throw new Error 'Must specify non-negative dimension count'

        super length
        (@[idx] = 0) for idx in [0..length - 1]

      copyFrom: (v) ->
        if v not instanceof Vector or v.length isnt @length
          throw new Error 'Cannot copy from vector of different length'

        for dim in [0..len - 1]
          @[dim] = v[dim]

      add: (v) ->
        if v not instanceof Vector or v.length isnt @length
          throw new Error 'Cannot add vector of different length'

        for dim in [0..len - 1]
          @[dim] += v[dim]

      multiplyBy: (n) ->
        unless 'number' is typeof n or n instanceof Number
          throw new Error 'Cannot multiply by non-scalar'

        for dim in [0..len - 1]
          @[dim] *= n
```

In this context the input validation is useful because it makes the resulting
error messages more useful and the methods more predictable. For some reason,
in CoffeeScript, [0..NaN] is []. Without validation the above would have some
unpleasantly surprising behaviors.

# My expectations

#e Everything except 'return' and 'throw' are expressions

## Variables are not values

### A variable is an alias, container or pointer

If I were explaining the assignment operation to a new programmer I would tell
her that assignment changes the meaning of the variable in the code which
follows the assignment. It behaves like the english expression 'now contains'
or 'now means'.

```coffee
   x = 1     # until the next assignment, the letter x means the number one
   x = x + 1 # now x means 2, but 1 has not been changed
```

A variable is a convenient alias for a value. It gives the programmer a more
convenient way of referencing values than indexing the values as in, for
example, the parameters to shell scripts:

```sh
    #!/bin/sh

    function () {
      echo $[ $1 + $2 ]
    }
```

vs

```coffee
    module.exports =
      (firstNum,  secondNum) ->
       firstNum + secondNum
```

I expect assignment to a variable to change the variable, not the variable's
previous value. I think of them like registers in assembly.

```asm
    fourtytwo:
       DATA 42

    main:
       MOV AX, 0x42
       MOV BX, AX
       MOV AX, 0x666
       CMP AX, BX
       JNE correct
    incorrect:
       # what is wrong with you
    correct:
       # damn right
```

### Values have types, variables do not

The 'type' of a variable is just the type of its current contents.

```coffee
    'number' is typeof 1     # true
    myVar = 1
    'number' is typeof myVar # true

    myVar = 'one'
    'string' is typeof myVar # true now
```

## Values are copy-on-write

```coffee
   hello    = 'hello'
   greeting = hello
   greeting = [greeting, 'world'].join ' '

   hello is 'hello' # true
```

## Programs should be liberal in what they accept and strict in what they produce

Compilers should be optimistic and trusting. Values should be coerced as
needed.

The programmer should not be required to input redundant information. If the
compiler can safely and reliably infer the programmer's intent, it should do
so. Ambiguous input will necessarily generate an error.

```coffee
    # The following expressions evaluate to true.

    1 + 1.0 is 2
    1 + 1.1 is 2.1
```

In principle I like when strings and numbers are usefully coerced but do not
expect or rely on it and would not included the feature in a language of my
own design.

## Syntactic operators should only perform one operation

Many of my other favorite languages violate this, but it's not a problem for
me since I don't use operators more than one way. That is, I don't add strings
with '+' and I don't expect 'x' * 3 to evaluate to 'xxx'. Perl has the
preferable behavior: the math operators (+, -, ==) coerce their args to
numbers. The string operators (., eq, gt) coerce their args to strings.
