{ Schema, model } = require 'dynamoose'

module.exports =
  model 'NamedDescription', new Schema
    name: String
    description: String
