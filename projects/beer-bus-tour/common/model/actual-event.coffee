{ Schema, model } = require 'dynamoose'

module.exports =
  model 'ActualEvent', new Schema
    scheduled:  String
    actualTime: String

