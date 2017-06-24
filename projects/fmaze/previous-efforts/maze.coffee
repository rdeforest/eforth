wires = {}
paths = {}

module.exports =
  pinName: pinName = (pin) ->
    if typeof pin is 'object'
      if pin.length is 1
        return pinName pin[0]

      if pin.length
        throw new Error "Invalid pin is long list: #{JSON.stringify pin}"

    switch typeof pin
      when 'number' then pin.toString()
      when 'object' then pin.box + " " + pin.pin
      when 'string' then pin
      else throw new Error "unknown pin format: #{pin}"

  canonical: canonical = (pin, pins...) ->
    console.log "canonical " + JSON.stringify arguments

    switch typeof pin
      when 'string' then expanded = [pin]
      when 'number' then expanded = [pin.toString()]
      when 'object'
        if pin.box
          expanded = [pin.box + " " + pin.pin]
        else
          expanded = canonical pin...
      else
        throw new Error "Unrecognized pin form: #{JSON.stringify pin}" 

    if pins.length
      expanded = expanded.concat canonical pins...

    return expanded

  boxMaker: boxMaker = (name) ->
    (pin, more...) ->
      [box: name, pin: pin].concat more...

  connect: connect = (pins...) ->
    [from, to, andAlso...] = canonical pins

    from = pinName from; wires[from] or= {}
    to   = pinName to  ; wires[to]   or= {}

    console.log "#{from} <-> #{to}"

    wires[from][to] = wires[to][from] = true

    if andAlso.length
      connect from, andAlso...
      connect to, andAlso...

  isConnected: isConnected = (pins...) ->
    console.log "isConnected #{pins.map((p) -> JSON.stringify p).join ', ' }"

    if typeof from is 'object'
      if from.length
        return isConnected from[from.length - 1], to
      else
        return from.pin is to[0]

    if typeof to is 'object'
      if to.length
      return isConnected from, to[0]

    [from, to] = canonical pins...

    return wires[from] and wires[from][to] or paths[from] and paths[from][to]

  trace: trace = (from, nextStep, moreSteps..., to) ->
    if from.length
      trace from...

    if not isConnected from, nextStep
      throw "can't trace: #{canonical from} not connected to #{canonical nextStep}"

    trace nextStep, moreSteps..., to

    if not from.length and not to.length
      from = pinName from
      to   = pinName to

      paths[from] or= {}
      paths[to]   or= {}

      paths[from][to] or= [nextStep, moreSteps...]
      paths[to][from] or= [nextStep, moreSteps...].reverse()
