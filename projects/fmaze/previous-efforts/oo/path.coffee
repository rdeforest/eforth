module.exports = class Path
  constructor: (@maze, @steps...) ->
    Object.defineProperties this,
      start: get: -> @steps[0]
      rest:  get: -> @steps[1..]
      end:   get: -> @steps[@steps.length -1]

  length: -> @steps.length

  connected: (pinOrPath) ->
    @map is pin.map and @end.pin is pin.pin

  toString: ->
    ("#{@maze}: [" +
     @steps.map((s) -> s.toString()).join(", ") +
     "]")
