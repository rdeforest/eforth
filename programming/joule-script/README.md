Joule in CoffeeScript

# WTF is Joule?

[Wikipedia](https://en.wikipedia.org/wiki/Joule_%28programming_language%29)
[Manual](http://www.erights.org/history/joule/index.html)

# How is this different?

- Implemented as a CoffeeScript-based DSL
- None of the unicode syntax voodoo
  - Comments not indicated by style (italics). Just use CoffeeScript comments.
- Joule limitations not imposed
  - You can do whatever you want in a server

In general,
  - keywords are in-scope functions which do what they should
	- @whatever performs trickery specific to this implementation

## Syntax

The Joule "dot" statement necessarily looks different:

    • A oper: arg1 arg2

becomes

    A.oper arg1, arg2

# What does it look like?

Taken from the manual:

		Server Dispatcher :: in> outs

			• in> → msgs

			ForAll msgs ⇒ message
				Define size
					• outs count: size>
				endDefine

				Define index
					• Random below: size index>
				endDefine

				Define out
					• outs get: index out>
				endDefine

				• out message
			endForAll
		endServer

Our version (maybe) looks like:

```coffee

		Server Dispatcher: (input, outs) ->
      input.fwd 'msgs' # tell 'input' to forward to 'msgs'

      @forAll msgs: (message) ->
        @define
          size:  (outs,  size ) -> @o outs,   count: null, size
          index: (size,  index) -> @o Random, below: size, index
          out:   (index, out  ) -> @o outs,   get:   index, out

        @o out: message
```

So ... that.

@o is a 'send' operation taking a single-key object whose key is the name of a
bound Port.

@forAll declares that whenever something comes in for 'msgs' that it should be
handled with the given block.

@define declares a binding in the context of the @forAll

When a pipe is in CoffeeScript scope, such as 'message' above, regular method
invocation is a shortcut for the equivalent @o call.

# Syntax

```coffee
    @o port: message: arg, args...

    @define port: (inputs...) ->
      # create a port only visible in this scope

    @forAll port: (message) ->
      # create a port on the outside of the current scope whose messages are
      # handled by the function provided

    Server name: (
```

# Semantics

## Server

## Channel

## Acceptor

## Distributor
