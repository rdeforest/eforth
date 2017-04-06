Math.sum ?= (x, xs...) ->
  if 'object' is typeof x
    x = Math.sum x...

  if xs.length
    x += Math.sum xs...

  x

minors = (matrix) ->
  (x, y) ->
    matrix
      .filter (row, i) -> i isnt y
      .map (row) ->
        row.filter (val, j) -> j isnt x

determinant = (m) ->


crossProduct = (u, v) ->
  matrix = [
    (new Array u.length).fill Symbol 'unit vector'
    u
    v
  ]

  determinant matrix

class Vector
  constructor: (@v) ->
    @v ?= (new Array DIMENSIONS).fill 0

  add: (v) ->
    if v.v.length isnt @v.length
      throw new Error "incompatible vectors"

    v = v.v
    summed = @v.map (x, i) -> x + v[i]

    new Vector @x + v.x, @y + v.y

  scale: (s) -> new Vector @v.map (x) -> x * s

  crossProduct: (v) ->

Physics =
  # m^3/kg/s^2
  G = 6.67408 * 10 ** -11

  gravity: (bodyA, bodyB) ->
    mm = bodyA.mass * bodyB.mass
    rSquared = Math.sum(
      for x, dim in bodyA.v
        (x - bodyB.v[dim])**2
    )
    Physics.G * mm / rSquared

module.exports = {Vector, Physics}
