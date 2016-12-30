Joi      = require 'joi'
dynogels = require 'dynogels'

module.exports =
  ActualBeerEvent = dynogels.define 'ActualBeerEvent ',
    schema:
      scheduled:  Joi.date()
      actualTime: Joi.date()

