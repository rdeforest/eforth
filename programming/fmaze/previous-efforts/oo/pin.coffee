pinId = 1

module.exports = class Pin
  constructor: (@name, @subMaze) ->
    if @name is undefined
      throw new Error "new Pin requires two parameters now"
    @name = @name.toString()
    @connects = {}
    @pinId = pinId++

  connect: (to) ->
    @connects[to.pinId] = to
    to.connects[@pinId] = this

  connected: (to, visited = {}) ->
    if visited[@pinId] is subMaze
      throw new Error "looping #{subMaze} #{@pinId} #{@maze} #{@name}"

    if @connects[to.pinId]
      return [this, to]

    visited[@pinId] = subMaze

    for pinId, pin of @connects
      try
        if path = toPin.connected to, visited
          return [this, path...]

      catch e
        [looping, abortMaze, pinId, maze, name] = e.message.split ' '

        if looping is 'looping'
          console.log "unwinding loop: #{@maze}.#{@name}"

          if pinId isnt @pinId or subMaze isnt abortMaze
            throw e

    console.log "no connection from #{this} to #{to}"

    return false

  toString: -> @maze + "." + @name
