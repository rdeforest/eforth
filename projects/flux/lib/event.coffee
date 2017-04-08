module.exports =
  class Event
    constructor: (@dispatcher, @name, @data->

    dispatcher: require './dispatcher'
