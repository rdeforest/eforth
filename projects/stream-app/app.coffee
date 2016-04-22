module.exports = class StreamApp
  constructor: (@initState) ->
    @sessions = []

  connect: (stream) ->
    sessionNum = @sessions.length
    curState = -> @sessions[sessionNum][1]
    newState = (s) -> @sessions[sessionNum][1] = s

    stream.on 'data', (d) ->

    @sessions.push [stream, @initState]

