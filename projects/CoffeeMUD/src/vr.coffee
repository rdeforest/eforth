{ Persisted } = require './persistence'
{ needs, combines } = require './aspect'

VR = {}

defineVr = (klass) ->
  VR[klass.constructor.name] =
    new Persisted

defineVr class Thing
  constructor: (aspects...) ->
    super aspects..., Container, Located, Observable

defineVr class Actor extends Thing
  constructor: (aspects...) ->
    super aspects..., Observer, Initiator

defineVr class Observable extends Aspected
  constructor: (@these) ->
    super Visible, Audible, Tactile, Fragrant, Flavored

    @_needs Located, Container

defineVr class Container
  constructor:   (@these)      -> @contents = []

  thingLeaving:  (those, to  ) ->
  thingEntering: (those, from) ->

  thingLeft:     (those, to  ) ->
    @contents = @contents.filter (item) -> item isnt those

  thingArrived:  (those, from) ->
    @contents.push those

defineVr class Located
  constrsucto: (@these) ->
    @location = undefined

  moveTo: (destination) ->
    @location  .thingLeaving  @these, destination
    destination.thingEntering @these, @location

    @location  .thingLeft     @these
    destination.thingArrived  @these

    @location = destination

