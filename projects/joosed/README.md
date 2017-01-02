# Like Joose, but still maintained?

Trying to implement Moose for JavaScript in CoffeeScript

# Example usage

```coffee
    import * from 'joosed'

    export { Point }

    rwNumber = is: 'rw', isa: 'number'

    Point = JCLass ->
      has
        x: rwNumber
        y: rwNumber

      sub 'clear', -> @x = @y = 0

    JClass Point3d, ->
      isa Point

      has z: rwNumber

      after 'clear', -> @z = 0
```
