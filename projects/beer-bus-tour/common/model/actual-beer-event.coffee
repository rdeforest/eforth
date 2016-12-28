{ Schema, model } = require 'dynamoose'

module.exports =
  model 'ActualBeerEvent', new Schema
    scheduled:  String
    actualTime: String

