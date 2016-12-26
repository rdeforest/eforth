moment  = require 'moment'
tripLog = require './trip-log'

{ TRIP_TIME_EXP_AVERAGE_DECAY_FACTOR
} =
  require './config'

{ Schema, model } = require 'dynamoose'

# A Trip is a particular journey between two stops.
module.exports =
  model 'Trip', new Schema
    vehicle: Object
    src: Object
    dst: Object

###
    started: ->
      @started = moment()

    ended: ->
      @ended = moment()
      tripLog.add @
###
