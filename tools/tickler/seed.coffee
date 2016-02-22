# Seed data for screwing around

app = require '.'

for name in 'Participant Item Schedule'.split ' '
  global[name] = app.models[name]


module.exports =
  dummies:   dummies   = []
  items:     items     = []
  schedules: schedules = []

for n in [1, 2]
  Participant.create
      username: 'testDummy' + n
      password: 'nah'
      email: 'dummy@defore.st'
    .then (user) ->
      dummies.push user
      user.schedules.create
          interval: 86400
        .then (daily) ->
          for i in [1, 2]
            user.items.create
                contents: "item " + i
                schedule: daily
              .then (item) ->
                items.push item

