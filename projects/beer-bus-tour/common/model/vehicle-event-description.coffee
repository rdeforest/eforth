#{ Schema, model } = require 'dynamoose'
NamedDescription = require 'named-description'

module.exports =
  class VehicalEventDescription extends NamedDescription
    tripId:    'string'
    change:    'string'
