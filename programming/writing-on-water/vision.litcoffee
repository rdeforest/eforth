# What Does it Do?

What if there were a library...

    wow = require '.'

Which could provide an enviroment like MOO and ColdMUD...

    demo = wow
      .withDb 'example'
      .do ->
        console.log $root, $sys

(outputs #1, #0 or something)

The function provided is executed in a NodeJS VM sandbox so that this library
can manage the global namespace behind the scenes.

# What _Else_ Does it Do?

How about a classic MUD REPL?

    readline = require 'readline'
