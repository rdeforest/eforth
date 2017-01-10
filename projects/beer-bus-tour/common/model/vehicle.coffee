Location     = require './location'
VehicleEvent = require './vehicle-event'
Reservation  = require './reservation'
Status       = require './status'

statusPromise =
  Status.declareStatuses
    reservation: [ 'accepted' ]

module.exports = ({make}) ->
  Vehicle = make 'Vehicle',
    schema:
      location      : 'string'
      licensePlate  : 'string'
      fleetVehicleId: 'string'
      seatCapacity  : 'number'

  Vehicle::activeReservations = ->
    new Promise (resolve, reject) ->
      statusPromise.then (status) ->
        Reservation
          .query 'vehicleId'
          .eq @id
          .and 'status'
          .eq status.reservation.accepted
          .exec (err, reservations) ->
            if err
              reject err
            else
              resolve reservations

  Vehicle::reservedSeats = ->
    @activeReservations
      .then (res) ->
        .map (res) -> res.seatCount
        .reduce (a, b) -> a + b

  Vehicle::seatsRemaining = ->
    @reservedSeats()
      .then (reserved) -> @seatCapacity - reserved

  Vehicle::acceptReservation = (reservation, seats = Math.min @seatsRemaining, reservation.seatCount) ->
    if seats < 1
      throw new Error "vehicle is full"

    reservation.acceptedBy @

  createEvent = (change, time = moment()) = ->
    VehicleEventDescription { time, change, @vehicle.gvehicalId, trip: @vehicle.id }

  for change in VEHICLE_EVENT_NAMES
    Vehicle::[change] = (time = moment()) -> @vehicle.g_createEvent change, time



