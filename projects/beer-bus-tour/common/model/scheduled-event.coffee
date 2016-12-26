{ Schema, model } = require 'dynamoose'

module.exports =
  model 'ScheduledEvent', new Schema
    eventType:     String
    scheduledTime: Object
