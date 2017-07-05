# x is time, y is distance
#
# y = v * x + p
#
# a.v * x + a.p = b.v * x + b.p
# a.v * x - b.v * x = b.p - a.p
# x(a.v - b.v) = b.p - a.p
# x = (b.p - a.p)/(a.v - b.v)

show = (args...) ->
  for arg in args
    for desc, value of arg
      console.log desc, (JSON.stringify value).replace /\n/g, '\n  '

line = (a, b) ->
  v: a, p: b
  
EPSILON = 1/10**10

meetAt = (a, b) ->
  y = [b.p - a.p, a.v - b.v]

  ax = [y[0] * a.v + a.p * y[1], y[1]]
  bx = b.v * y + b.p

  if Math.abs(ax - bx) > EPSILON
    throw new Error "I'm bad at math."

  where = {x: ax[0] / ax[1], y: y[0] / y[1]}
  #show where: [a, b, where]
  where

concat = (a, b) -> a.concat b

module.exports =
  runnersMeetings = (startPosition, speed) ->
    runners =
      for p, i in startPosition
        line speed[i], p

    meetings = {}

    for r1, i in runners[..-2]
      for r2, j in runners when j > i and r1.v isnt r2.v
        where = meetAt r1, r2

        if where.y >= 0
          meeting = {i, j, where}
          #show added: meeting
          (meetings[where.y] ?= []).push meeting

    max = 1
    #show {meetings}

    locations =
      Object.keys meetings
        .reduce ((locations, location) ->
          locations[location] ?= {}
          for meeting in meetings[location]
            locations[location][meeting.i] or= 1
            locations[location][meeting.j] or= 1
            max = Math.max max, Object.keys(locations[location]).length
        ), {}

    #show {locations}

    if max > 1
      max
    else
      -1

#runnersMeetings [1, 4, 2], [27, 18, 24]
