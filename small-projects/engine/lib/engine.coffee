{Event, Participant} = require '.'

class Engine
  constructor: ->
    @world = new Participant.World "the world"

module.exports = {Engine}
