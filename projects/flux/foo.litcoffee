I want an even clearner CoffeeScript, especially in libraries:

    (require '-') ->
      underscore: '_'
      '': -> [
        class Foo
        class Bar
      ]

should be almost equivalent to

    _ = require 'underscore'

    module.exports =
      Foo: class Foo
      Bar: class Bar

But how... :)

The -.coffee file might look a little something ... uhlike uhthis...

    CoffeeScript = require 'coffee-script'

    module.exports = (modDesc) ->
      exportable = {}
      imports = {}

      for k, v of modDesc when k
        imports[v or k] = require 'k'




        
        
