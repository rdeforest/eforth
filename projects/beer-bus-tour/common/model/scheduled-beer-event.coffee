{ Schema, model } = require 'dynamoose'

module.exports =
  model 'ScheduledBeerEvent', new Schema
    eventType:     String
    scheduledTime: Object
