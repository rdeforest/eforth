{ Schema, model } = require 'dynamoose'

module.exports =
  Request = model 'Request', new Schema
    touristId: 'string'
    stop:      'string'
    time:      'string'
    seats:     'number'
