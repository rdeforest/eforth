moment       = require 'moment'
beerEventLog = require './beer-event-log'

{ Schema, model } = require 'dynamoose'

# An ActualTrip is a particular journey between two stops.
module.exports =
  ActualTrip = model 'ActualTrip', new Schema
    vehicle: Object
    src: Object
    dst: Object

  ActualTrip::started = ->
    @started = moment()

  ActualTrip::ended = ->
    @ended = moment()
    beerEventLog.add @
