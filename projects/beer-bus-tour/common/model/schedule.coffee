{ Schema, model } = require 'dynamoose'

module.exports =
  model 'ScheduledJourney', new Schema
    journeys: [Object]
