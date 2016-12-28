{ Schema, model } = require 'dynamoose'

module.exports =
  model 'ScheduledTrip', new Schema
    depart: Object
    arrive: Object
