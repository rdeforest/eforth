# Pin:  Pin  = require './pin'
# Path: Path = require './path'

# Handles .toString()

warn = (warning...) ->
  console.log "WARNING: ", warning...

pinId = 1

class Pin
  constructor: (@name, @maze) ->
    @shorts = {}
    @pinId = pinId += 1

  addShort: (to) ->
    if 'object' isnt typeof to
      console.log 'extra barf'
      throw new Error "invalid short"

    if to.pinId isnt @pinId
      @shorts[to.toString()] = to

  toString: ->
    if @maze
      @maze + "." + @name
    else
      @name

  connected: (otherPin) -> @shorts[otherPin.toString()]

module.exports =
  Maze: class Maze
    constructor: ->
      @pins = {}
      @outerPins = {}
      @innerPins = {}
      @paths = {}

    canonical: (pins...) ->
      canon = []
      
      for pin in pins
        switch
          when 'number' is typeof pin then canon.push @addPin pin, ''
          when 'string' is typeof pin then canon.push @addPin pin, ''
          when pin.shorts             then canon.push pin
          when pin.length             then canon.push @addPin pin...

          when 'object' is typeof pin
            for maze, name of pin
              canon.push @addPin name, maze

          else
            warn "Could not canonize pin, ignored it: " +
                 JSON.stringify pin, null, 2

      return canon

    addPin: (pinName, maze) ->
      pin = new Pin pinName.toString(), maze
      longName = pin.toString()

      if existing = @pins[longName]
        return existing
          
      @pins[longName] = pin

      if maze
        @innerPins[longName] = pin
      else
        @outerPins[longName] = pin

    edgeShorts: (pin) ->
      if not pin.maze
        return []

      if outer = @outerPins[pin.name]
        for pinName, short of pin.shorts
          short
      else
        []

    addWireOneWay: (from, to) ->
      if 'object' isnt typeof from
        console.log 'barf from'

      if 'object' isnt typeof to
        console.log 'barf to'

      from.addShort to

      for short in @edgeShorts to
        from.addShort short

      this

    addWire: (from, to) ->
      this
        .addWireOneWay from, to
        .addWireOneWay to, from

    connect: (pins...) ->
      pins = @canonical pins...

      while pins.length > 1
        from = pins[0]
        pins.shift()

        for to in pins
          @addWire from, to

      this

