# ATP: All Transmission Programming

Functional programming to the MAX!!

# Huh?

Functional programming is great, but it's too recursive. Instead of returning
we should be forwarding, like in pre-Promise Node protocols and what-not.
Instead of expecting a response, we should tell a service where we want the
result sent.

# What ... what does that even mean?

We're changing callbacks from the exception to the norm. We're also brining
Unix shell patterns to programming _full force_.

And yes, this is partly inspired by Joule and other flow-based languages.

## For example

The old way:

    matcher = (pattern) -> (s) -> not not s.match pattern

    grep = (pattern, lineSource) ->
      filter = matcher pattern

      for line from lineSource when filter
        yield line

The new way:

    filter = (pattern) -> (s, dest) ->
      if s.match pattern then dest s

    grep = (pattern, lineSource, dest) ->
      forwarder = filter pattern

      for line from lineSource
        forwarder line, dest

But... but that's more code... :(
