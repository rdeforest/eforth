# grams

masses =
  earth: 6 * 10 ** 27
  sun  : 2 * 10 ** 33

# meters
distances =
  au: 1.5 * 10 ** 11

module.exports = (engine) ->
  {Participant, Event} = engine
  {Vector, Physics} = require './toy-physics'

  class Body extends Participant
    constructor: (name, info = {}) ->
      super
      { @pos = new Vector
        @vel = new Vector
      } = info

    applyForce: (f, dt) ->
      @vel.add f.scale dt

  class MassiveBody extends Body
    constructor: (name, info = {}) ->
      super
      { @mass = masses.earth
      } = info

    applyGravity: (bodies...) ->
      vel = @vel

      for body in bodies
        vel = vel.add 


      

    receiveEvent: (event) ->
      switch event.constructor
        when TickEvent
          @calculatePath()
          @emitMovement()

    calculatePath: 
  
