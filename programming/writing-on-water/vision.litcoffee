What if there were a library...

    wow = require '.'

Which could provide an enviroment like MOO and ColdMUD...

    wow.using 'example', ->
      console.log $root, $sys

(outputs #1, #0 or something)

The function provided is executed in a NodeJS VM sandbox so that this library
can manage the global namespace behind the scenes.

There could also be a REPL which runs inside one of these sandboxes.


