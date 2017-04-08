WORLD_SIZE = 100


balls = null

module.exports = (engine) ->
  arena = engine.createWorld
    dim: 2
    size: [WORLD_SIZE, WORLD_SIZE]
    discrete: false
    timeScale: engine.timeScales.TICK

  {Body} = arena.classes()

  class Ball extends Body
    constructor: (info) ->
      super info
      @solid = true
      @radius = 1.25 * 2.54 # 1.25 in * 2.54 cm/in
      [@x, @y] = [0, 1].map -> Math.random() * WORLD_SIZE
      [@dx, @dy] = [0, 0]

  balls =
    [0..2]
      .map (i) ->
        b = new Ball i
