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
      next2 = (next1 + dt)
      next3 = (next2 + dt)
      jump3 = (now   + dt * 3)
      diff = max distance between next3 and jump3 (error accumulation)

    if diff > maxError
      dt /= 2 
      now = next
    else if diff > minError
      now = next2
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

distanceScale = 1.5 * 10 ** 6 # km/pixel

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

dt = 1

trials = trial body, dt

generateTrials = ->
  trials.push trial trials[0], dt
  trials.push trial trials[1], dt
  jump = trial body, dt * 2

calculateError = ->
  next2 = trials[1]

  most = 0

  for b, i in jump
    for dim, di in b.loc
      dist = abs(b.loc[di] - 
    


adjustDt = ->

while running
  generateTrials()
  calculateError()
  adjustDt()
  updateBodies()
  showUpdate()
