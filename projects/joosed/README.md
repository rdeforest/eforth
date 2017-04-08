# Like Joose, but still maintained?

Trying to implement Moose for JavaScript in CoffeeScript

# Example usage

```coffee
    {define} = require 'joosed'

    rwNumber = is: 'rw', isa: 'number'

    module.exports = {Point, Point3d} = define
      Point: ->
        @has
          x: rwNumber
          y: rwNumber

        @does 'clear', -> @x = @y = 0

      Point3d: ->
        @isa Point

        @has z: rwNumber

        @after 'clear', -> @z = 0
```
