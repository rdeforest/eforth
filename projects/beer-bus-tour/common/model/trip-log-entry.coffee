moment  = require 'moment'

Trip    = require './trip'
tripLog = require './trip-log'

module.exports =
  class TripLogEntry
    constructor: (@trip) ->

    started: (@departed = moment()) ->
    ended:   (@arrived  = moment()) ->
      tripLog.add @
      
