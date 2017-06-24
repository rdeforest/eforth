# Intro

# Just enough Real Life to motivate this thing.

module.exports = (pmbok) ->
  pmbok.program 'Life Improvement',
    pmbok.program 'Live Consistently',
      pmbok.objective 'have and improve routines',
        everyDay = pmbok.process 'everyDay',
          scheduleTemplate:
            start: "06:30"
            blocks: [
              { wake: "5m" }
              { takeMeds: "10m" }
              { journal: "15m" }
              { breakfast: "1h" }
              { today:
                  templateVar: "today specifically"
                  defaultDuration: "11h"
              }
            ]
          weekday:
            extends: "scheduleTemplate"
            vars:
              "today specifically":
                blocks:
                  { work: "4h" }
                  { lunch: "1h" }
                  { work: "4h" }
