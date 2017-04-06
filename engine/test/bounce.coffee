{Participant, Event} = require '../lib'

arena = width: 100, height: 100

balls = null

class Ball extends Participant
  constructor: ->
    super
    [@x, @y] = [0, 1].map -> Math.random() * 100
    [@dx, @dy] = [0, 0]

  receiveEvent: (event) ->
    if event instanceof Event.Tick
      dest = 

balls =
  [0..2]
    .map (i) ->
      b = new Ball i
      Participant.world.subscribe b

for b, i in balls
  b.others = Array.from(balls)
  b.others.splice i, 1
