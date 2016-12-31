module.exports = (util) ->
  class VehicleController
    constructor: (@vehicle) ->


    
createEvent = (change, time = moment()) = ->
  new VehicalEventDescription { time, change, @vehicle.gvehicalId, trip: @vehicle.id }

for change in VEHICLE_EVENT_NAMES
  VehicleController::[change] = (time = moment()) -> @vehicle.g_createEvent change, time



