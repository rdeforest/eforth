# No test framework or anything, just a smoke test

{JClass, isa, has, does, after} = require '..'

Point = JClass ->
  rwNumber = is: 'rw', isa: 'number'

  Point = JCLass ->
    has
      x: rwNumber
      y: rwNumber

    does 'clear', -> @x = @y = 0

    does 'shift'

  JClass Point3d, ->
    isa Point

    has z: rwNumber

    after 'clear', -> @z = 0

origin   = new Point

origin3d = new Point3d


