Location = require './location'
TripLogEntry
         = require '.trip-log-entry'

module.exports =
  class Vehicle extends Location
    constructor: (@location) ->
      @tripLogEntry = null
      @destination  = null
    
    scheduleTrip: (@destination, @departureTime) ->
      @trip = new Trip @vehicle, @location, @destination

    depart: -> @trip.started()
    arrive: ->
      @trip.ended()
      [@location, @destination] = [@destination, null]

