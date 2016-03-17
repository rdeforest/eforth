pinName = (pin) ->
  switch typeof pin
    when 'number' then pin.toString()
    when 'object' then pin.box + " " + pin.pin
    when 'string' then pin
    else "unknown pin format"

boxMaker = (name) ->
  (pin, more...) ->
    [box: name, pin: pin].concat more...

maze =
  wires: {}
  paths: {}

module.exports =
  connect: connect = (from, to, andAlso...) ->
    from = pinName from; wires[from] or= {}
    to   = pinName to  ; wires[to]   or= {}

    wires[from][to] = wires[to][from] = true

    if andAlso.length
      connect from, andAlso...
      connect to, andAlso...

  isConnected: isConnected = (pins) ->
    [from, to] = pins.map (p) -> pinName p

    return wires[from][to] or paths[from][to]

  trace: trace = (from, nextStep, moreSteps..., to) ->
    if not isConnected from, nextStep
      return false

    if not trace nextStep, moreSteps..., to
      return false

    from = pinName from; paths[from] or= {}
    to   = pinName to;   paths[to]   or= {}

    paths[from][to] or= [nextStep, moreSteps...]
    paths[to][from] or= [nextStep, moreSteps...].reverse()

  boxMaker: boxMaker
