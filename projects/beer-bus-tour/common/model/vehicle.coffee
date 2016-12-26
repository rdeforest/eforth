Location = require './location'
TripLogEntry
         = require '.trip-log-entry'

{ Schema, model } = require 'dynamoose'

module.exports =
  model 'Vehicle', new Schema
    location: 'string'
