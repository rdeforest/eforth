{Dispatcher, Event, ReduceWorker} = require '../lib'

class SimStateWorker extends ReduceWorker
  constructor: (dispatcher, name, @precursors = []) ->
    super dispatcher, name

  getInitialState: -> []

  precursorIds: -> @precursors.map ({id}) -> id

  areEqual: ({tick: a}, {tick: b}) -> a is b

  handleTick: (state, event) ->
    @dispatcher.waitFor @precursors
    newValues = @evaluator state, event
    newValues.tick = event.tick

dispatcher = new Dispatcher

makePhase = (name, after, additions...) ->
  phase = new SimStateWorker dispatcher, name,
    switch
      when not after then []
      when not Array.isArray after then [after]
      else after

  Object.assign phase, additions...

# In a world...
G = 1  # gravity scalar
R = 10 # repulsion scalar

class Vector
  @isNumArray: (v) ->
    Array.isArray v and
      not v.find (x) ->
        'number' isnt typeof x or
        x.toString() is 'NaN'

  constructor: (v) ->
    self = if Vector.isNumArray v then Array.from v else []
    Object.setPrototypeOf self, Vector::
    return self

  diff: (b) -> @map (x, i) -> x - b[i]
  mult: (b) -> @map (x, i) -> x * b[i]
  powr: (n) -> @map (x   ) -> x ** n
  scal: (c) -> @map (x   ) -> x * c
  zero:     -> @map        -> 0
  unit:     -> @map        -> 1

class Body
  constructor: ({@name, @mass, @loc, @vel}) ->

gravityBetween = (a, b) ->
  r  = a.loc.diff b.loc
  r3 = r.powr 3
  mm = a.mass * b.mass

  Gmm = G * mm

  fOverR = r3.map (x) -> Gmm / x

  fHat = r.mult fOverR

repulsionBetween = (a, b) ->
  r  = a.loc.diff b.loc
  r5 = r.powr 5
  Rmm = a.mass * b.mass * R
  fOverR = r5.map (x) -> Gmm / x
  fHat = r.mult fOverR

forceBetween = (a, b) ->
  repulsion = repulsionBetween a, b
  attraction = gravityBetween a, b

  fHat = attraction.diff repulsion

force = makePhase null,
  evaluator: (state, event) ->
    return unless try zero = worker.position.state[0].loc.zero()
    bodies = worker.position.state

    (newState = bodies.map -> zero)
      .map (a, i) ->
        for b in bodies when b.id > a.id
          accel = forceBetween a, b

          newState[a.id] = newState[a.id].plus accel
          newState[b.id] = newState[b.id].diff accel

    newState

velocity = makePhase force,
  evaluator: (state, event) ->
    forces = workers.force.state
    workers.position.state
      .map (body) ->
        m = body.m
        f = forces[id]
        dv = state[id].map (v, i) -> v + f[i] / m

  handleNewBody: (state, event) ->
    {id, mass, loc, vel = loc.map -> 0} = event.data
    newState = state.map((i) -> i)
    (newState[id] = vel).mass = mass
    newState

position = makePhase velocity,
  evaluator: (state, event) ->
    velocities = workers.velocity.state
    newState = state
      .map (body) ->
        {id, v} = body
        v.map (x, i) -> v[x] + velocities[i]

  handleNewBody: (state, event) ->
    body = new Body event.data
    {id, v, m, name} = event.data
    newState = state.map((i) -> i)
    newState[id] = {stuck, name}
    newState

workers = {force, velocity, position}

dispatcher.send 'newBody',
  name: "the first", id: 0, m: 10000
  v: [0, 0], dv: [0, 0]

dispatcher.send 'newBody',
  name: "the second", id: 1, m: 1
  v: [100, 0], dv: [0, 0.1]

position.addListener ->
  console.log "Motion:\n" +
    position.state
      .map (body) -> "  #{body.name}: #{body.join ","}"
      .join "\n"

Object.assign module.exports,
  workers, {dispatcher}
