TourLeg = require './tour-leg'

module.exports =
  class Schedule
    constructor: (@name) ->
      @tourLegs = []

    add: (tourLeg) ->
      @trips.push tourLeg
      return @
