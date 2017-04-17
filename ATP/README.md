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

    matcher =
      (pattern) ->
        (s) ->
          not not s.match pattern

    grep = (filter, lineSource) ->
      for line from lineSource when filter
        yield line

    grep matcher(/foo/), lineIterator

The new way:

    matcher = (pattern) -> (s, dest) ->
      if s.match pattern then dest s

    grep = (filter, lineSource, dest) ->
      for line from lineSource
        filter line, dest

    grep matcher(/foo/), lineIterator, someConsumer

But... but that's more code... :( I think I got the design wrong.


