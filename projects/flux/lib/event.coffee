module.exports.Event =
  class Event
    constructor: (@dispatcher, @name, @data) ->
