# Beer bus tour

Tourists indicate interest in changing locations. Bus assignment based on
demand.

# Classes

## Undescribed

- ActualVehicleEvent
  - has
    - UUID
    - time
    - Vehical
    - VehicalEventType
    - location is a Stop, Trip or Coordinates?

- Status
  - has
    - statusType
    - name

## Referents

These classes also have a shortName, displayName and desription. These
classes add nothing beyond those defaults.

- VehicalEventType

- Stop
  - belongsTo
    - Trips

## The rest

These classes have all the above in addition to what is listed.

- Trip
  - has
    - Stops from, to

- ActualTrip
  - has
    - Vehicle
    - Trip
    - ActualBeerEvents depart, arrive
  - belongsTo
    - Reservations

- Vehicle
  - has
    - licensePlate
    - fleetVehicalId
    - capacity
  - calculates
    - availableSeats
  - does
    - acceptReservation reservation, seats
    - reRoute           destination
    - departed          time
    - arrived           time

- Tourist
  - has
    - account   (name, email, auth, billing, etc)
    - notes     (used by support)
    - location is a Stop or Vehical
  - does
    - placeRequest  destination, time, seats
    - cancelRequest
    - boardVehical  time, seats
    - exitVehical   time, seats

Tourists place Requests to obtain Reservations.

- Request
  - belongsTo
    - Tourist
    - Reservations
  - has
    - requestStatus
    - requestedStop
    - requestedTime
    - requestedSeats

One or more Reservations describe how the party described by a request are
split among multiple trips should the group be too large to fit in one
available vehicle.

- Reservation
  - has
    - Request
    - Vehicle
    - Status
    - seatCount
