Joi      = require 'joi'
dynogels = require 'dynogels'

module.exports =
  ScheduledTrip = dynogels.define 'ScheduledTrip ',
    schema:
      trips: Joi.string()
