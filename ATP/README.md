Functional programming to the MAX!!

# Huh?

Functional programming is great, but it's too recursive. Instead of returning
we should be forwarding, like in pre-Promise Node protocols and whatnot.
Instead of expecting a response, we should tell a service where we want the
result sent.

# What ... what does that even mean?

We're changing callbacks from the exception to the norm. We're also brining
Unix shell patterns to programming _full force_.

## For example

The old way:

    grep = (pattern, path, cb) ->
      fs.readFile path, (err, data) ->
        if err then return cb err

        data
          .toString()
          .split '\n'
          .filter (s) -> s.match pattern

The new way:

    grep = (pattern, path) ->
      fs.createReadStream path
        .pipe transform lines
        .filter pattern
