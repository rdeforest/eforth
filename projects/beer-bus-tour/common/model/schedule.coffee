Trip = require './trip'

module.exports =
  class Schedule
    constructor: (@name) ->
      @trips = []

    addTrip: (trip) ->
      @trips.push trip
      return @
