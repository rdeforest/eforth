{ Schema, model } = require 'dynamoose'

module.exports =
  Tourist = model 'Tourist', new Schema
    account:  'string'
    notes:    'string'
    location: 'string'
    request:  'string'

  Tourist::placeRequest = (destination, time, seats) ->
    throw new Error 'not implemented'

  Tourist::cancelRequest = ->
    throw new Error 'not implemented'

  Tourist::board = (vehical) ->
    throw new Error 'not implemented'

  Tourist::debark = (stop) ->
    throw new Error 'not implemented'
