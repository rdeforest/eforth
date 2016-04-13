pinName = (pin) ->
  switch typeof pin
    when 'number' then pin.toString()
    when 'object' then pin.box + " " + pin.pin
    when 'string' then pin
    else "unknown pin format"

isExit = (pin) -> 'number' is typeof pin

class Deep
  deepSet: (keys..., lastKey, value) ->
    andThen = this

    for key in keys
      andThen = (andThen[key] or= {})

    andThen[lastKey] = value

    return this
    
class Maze
  constructor: ->
    @wires = new Deep
    @paths = new Deep

  addWire: (a, b) ->
    [A, B] = [a, b].map (e) -> pinName e

    @wires
      .deepSet A, B, true
      .deepSet B, A, true

  addEdges: (pins...) ->
    for from, idx in pins
      for to in pins[idx + 1 ..]
        @addWire from, to

    return this

  addPath: (steps...) ->
    [start, middle..., end] = steps
    while steps.length > 1
      [from, to] = steps
      # validate step
      # throw on error
      @paths.deepSet start, end, middle...

    return this

boxMaker = (name) ->
  (pin, more...) ->
    [box: name, pin: pin].concat more...
      
a = boxMaker 'a'
b = boxMaker 'b'
c = boxMaker 'c'

exampleMaze = new Maze
  .addEdges    0, 14, 15, a 0
  .addEdges    1, a 3
  .addEdges    2, 11, a 4, b 6, c 0
  .addEdges    3, b 0

  .addEdges    4, b 3
  .addEdges    5, b 7
  .addEdges    6, a 2, c 5
  .addEdges    7, 9, 12, a 10

  .addEdges    8, b 2
  .addEdges   10, a 13

  .addEdges a  7, b 15
  .addEdges a  8, c 12
  .addEdges a  9, a 15
  .addEdges a 11, "minus"

  .addEdges b 10, c 3
  .addEdges b 13, c 14

  .addEdges c 6, c 7
  .addEdges c 9, "plus"

  
