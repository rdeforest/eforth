#{ Schema, model } = require 'dynamoose'
NamedDescription = require 'named-description'

module.exports =
  class Location extends NamedDescription
