#{ Schema, model } = require 'dynamoose'
NamedDescription = require 'named-description'

module.exports =
  class VehicalEvent extends NamedDescription
    tripId: 'string'
    change: 'string'
