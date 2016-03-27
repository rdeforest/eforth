warn = (warning...) ->
  console.log "WARNING: ", warning...

values = (o) -> v for k, v of o

pinId = 1

class Pin
  constructor: (@name, @maze) ->
    @outerSelf = null
    @innerSelf = {}
    @shorts = {}
    @pinId = pinId += 1

  connectOuter: (pin) ->
    if (pin.name isnt @name or
        pin.maze or
        not @maze)
      throw 'wat'

    @outerSelf = pin
    pin.innerSelf[@maze] = this

  addShort: (to) ->
    if to.pinId isnt @pinId
      console.log "shorting: #{@toString()} -> #{to.toString()}"

      for short in values @shorts
        to.addShort short

      @shorts[to.toString()] = to

  toString: ->
    if @maze
      @maze + "." + @name
    else
      @name

  connected: (otherPin) ->
    if @shorts[otherPin.toString()]
      return true

    if @maze and otherPin.maze is @maze
      @shorts[otherPin.toString()] =
        @outer.shorts[otherPin.name]

Pin.longName = (name, maze) ->
  if maze
    name + "." + maze
  else
    name

module.exports =
  Maze: class Maze
    constructor: ->
      @pins = {}

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
      longName = Pin.longName pinName, maze

      if not pin = @pins[longName]
        pin = new Pin pinName.toString(), maze
        @pins[pin.toString()] = pin

      if maze
        pin.outer = @addPin pinName
        @connectPair pin, outer
      else
        for inner in values @pins when inner.name is pinName
          @connectPair inner, pin

    connectPair: (inner, outer) ->
      inner.connectOuter outer
      maze = inner.maze

      for short in values outer.shorts when short.innerSelf[maze]
        @addWire inner, short.innerSelf[maze]

    edgeShorts: (pin) ->
      if not pin.maze
        #console.log "es outer: ", pin.toString()
        return []

      if pin.outerSelf
        #console.log "es no outerSelf: ", pin.toString()
        return []

      return values pin.outer.shorts

    addWireOneWay: (from, to) ->
      from.addShort to

      shorts = values to.shorts

      if to.maze
        shorts = shorts.concat @edgeShorts to

      console.log "#{to.name} shorts: ", shorts.map (s) -> s.toString()

      for short in shorts
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


# Pin:  Pin  = require './pin'
# Path: Path = require './path'

# Handles .toString()

