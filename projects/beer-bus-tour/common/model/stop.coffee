#{ Schema, model } = require 'dynamoose'
Location = require './location'

module.exports =
  class Stop extends Location
