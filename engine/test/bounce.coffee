{Participant, Event} = require '../lib'

WORLD_SIZE = 100

arena = width: WORLD_SIZE, height: WORLD_SIZE

balls = null

class Ball extends Participant
  constructor: ->
    super
    [@x, @y] = [0, 1].map -> Math.random() * WORLD_SIZE
    [@dx, @dy] = [0, 0]

  receiveEvent: (event) ->
    dt = event.dt || 1

    if event instanceof Event.Tick
      possibleDest = [@x + @dx * dt, @y + @dy * dt]
      emit MoveEvent

balls =
  [0..2]
    .map (i) ->
      b = new Ball i
      Participant.world.subscribe b

for b, i in balls
  b.others = Array.from(balls)
  b.others.splice i, 1
