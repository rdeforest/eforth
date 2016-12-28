moment       = require 'moment'
beerEventLog = require './beer-event-log'

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

{ Schema, model } = require 'dynamoose'

# An ActualTrip is a particular journey between two stops.
module.exports =
  ActualTrip = model 'ActualTrip', new Schema
    vehicleId: 'string'
    srcStopId: 'string'
    dstStopId: 'string'
    scheduledTripId: 'string'

  ActualTrip::createEvent (change, time = moment()) = ->
    new VehicalEventDescription {
      time, change
      vehicalId: @id()
      @scheduledTripId

  for change in VEHICAL_EVENT_NAMES
    ActualTrip::[change] = (time = moment()) -> @createEvent change, time

