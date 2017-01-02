Joi      = require 'joi'
dynogels = require 'dynogels'

module.exports =
  Tourist = dynogels.define 'Tourist ',
    schema:
      account:  Joi.string()
      notes:    Joi.string()
      location: Joi.string()
      request:  Joi.string()

Tourist::placeRequest = (destination, time, seats) ->
  throw new Error 'not implemented'

Tourist::cancelRequest = ->
  throw new Error 'not implemented'

Tourist::board = (vehical) ->
  throw new Error 'not implemented'

Tourist::debark = (stop) ->
  throw new Error 'not implemented'
