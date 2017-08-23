oneDayMillis =  1000 * # milliseconds
                  60 * # seconds
                  60 * # minutes
                  24   # hours

{lastRotation, healed, healing, unspent, spent} = require './tracking.json'

process = require 'process'

today = new Date
lastRotationDate = new Date lastRotation

if (dayNum = today.getDay()) is lastRotationDate.getDay() and Date.now() - lastRotation < oneDayMillis
  console.log "Already rotated today (at #{lastRotationDate})"
  process.exit 0

changes    = []
newTracking =
  lastRotationDate: Date.now()
  vessles:          newVessles = Object.assign {}, vessles
  bags:             newBags    = Object.assign {}, bags

addHealed()
emptySpent()
fillUnspent()

addHealed = ->
  if healing[dayNum]
    newVessles.healed += healingDayNum
    changes.push "Healed #{healingDayNum} points of damage, now at #{newVessles.healed}."

emptySpent = ->
  if spent
    healing[dayNum] = spent
    changes.push "Added #{spent} points of damage to the healing queue."

fillUnspent = ->
  if 0 <= diff = 7 - unspent
    unspent += replenished = Math.min diff, healed

    if replenished
    

