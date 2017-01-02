moment = require 'moment'
actualBeerEvent = require './actual-beer-event'

VEHICLE_EVENT_NAMES = [
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
module.exports = ({make}) ->
  make 'ActualTrip',
    schema:
      vehicalId: String

