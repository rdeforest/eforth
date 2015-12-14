###

  The idea is that our current 'dt' floats to be as large as possible without
  exceeding a tollerable quantity of error. The steady state is that the
  current 'dt' is actually half of what is used in the current update. The
  current update compares 

    sim(sim(now + dt * 2) + dt) 

  to

    sim(    now + dt * 3      )

  For each iteration
    calculate
      next1 = (now   + dt)
      next = (next1 + dt)
      next3 = (next + dt)
      jump3 = (now   + dt * 3)
      diff = max distance between next3 and jump3 (error accumulation)

    if diff > maxError
      dt /= 2 
      now = next
    else if diff > minError
      now = next
    else
      dt *= 1.5
      now = next3

###

Array.prototype.max = this.reduce (a, b) -> if a > b then a else b

body =
  name: []
  loc: []
  vel: []
  mass: []

addBody = (added) ->
  for k, v of body
    body[k].push added[k]

maxVel = 1.5 * 10 ** 6 # km (about one pixel)
minVel = maxVel / 3

addBody
  name: 'Sun'
  loc: [0, 0, 0]
  vel: [0, 0, 0]
  mass: 1.98855 * 10 ** 30 # kg

  radius: 100
  color: [255, 255, 63]

addBody
  name: 'Earth'
  loc: [1.5 * 10 ** 8, 0, 0] # km
  vel: [0, 29.78, 0] # km/s
  mass: 5.97237 * 10 ** 24

  radius: 10
  color: [31, 191, 255]

turnCrank = (bodies, dt) ->
  next = {}

  for b1, i in bodies
    next.acc = [0,0,0]

    for b2 in bodies[i + 1..]
      f = calcForce b1, b2

dt = 1

adjustDt = (err) ->
  jump = trial body, dt * 2

  err = calculateError jump, trials[1]

  if err > maxError
    dt /= 2
  else if err < minError
    dt *= 1.5
    trials = [...
    next = trials[2]

updateBodies = (next) ->

while running
  trials.push trial trials[0], dt
  adjustDt err
  updateBodies trials[0]
  trials.shift()
  showUpdate bodies
