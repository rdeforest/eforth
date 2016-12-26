moment  = require 'moment'
tripLog = require './trip-log'

{ TRIP_TIME_EXP_AVERAGE_DECAY_FACTOR
} =
  require './config'

# A Trip is a particular journey between two stops.
module.exports =
  class Trip
    constructor: (@vehicle, @src, @dst) ->
      @started = @ended = null

    started: ->
      @started = moment()

    ended: ->
      @ended = moment()
      tripLog.add @

