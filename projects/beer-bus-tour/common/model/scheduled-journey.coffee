{ Schema, model } = require 'dynamoose'

module.exports =
  model 'ScheduledJourney', new Schema
    depart: Object
    arrive: Object
