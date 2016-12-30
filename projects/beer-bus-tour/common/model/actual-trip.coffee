dynogels  = require 'dynogels'
moment    = require 'moment'

actualBeerEvent =
            require './actual-beer-event'

ACTUAL_EVENT_NAMES = [
    'requested'
    'scheduled'
    'canceled'
    'departed'
    'arrived'
    'passengers-entered'
    'passengers-exited'
    're-routed'
  ]

# An ActualTrip is a particular journey between two stops. Everything about it
# is captured in the events which reference it.
module.exports =
  ActualTrip = dynogels.define 'ActualTrip',
    schema:
      vehicalId: Joi.string()

  ActualTrip::_createEvent (change, time = moment()) = ->
    new VehicalEventDescription { time, change, @vehicalId, trip: @id }

  for change in VEHICAL_EVENT_NAMES
    ActualTrip::[change] = (time = moment()) -> @_createEvent change, time

