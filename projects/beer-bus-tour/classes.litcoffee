# extra notes

- A 'Guest' is an individual who is tagging along with a 'Tourist'
- A 'Tourist' is a member, has the app and can generate QR codes on the app

# User stories

## As a Tourist I want

- to know
 - options
  - where I can go on a single trip from 'here'
  - how long it will take to get to a given destination
  - how long the wait for a given trip will be
 - situation
  - what my current request is, if any
  - when I should expect to arrive at my destination
  - whether my announcements have been heard
   - and what is being done about them

- to announce
 - I have more/fewer people with me than I thought
 - I want
  - transport for me and 0 or more others to another stop
  - to cancel a previous request

## As a Driver I want

- to know
 - about a Vehicle I'm expected to be responsible for
   - where it is
   - how to identify it
   - its current disposition (transfer from other driver, pickup from lot)
   - where it is expected to be next
   - when my it is scheduled to depart
   - whether I have all the passengers who requested a ride
   - when it is expected to arrive

- to announce
 - I have
  - taken posession of a vehicle
  - received passengers
  - delivered passengers
  - departed from a location
  - arrived at a location

## As an EventHost I want

- to announce
 - what I have to offer
- to know
 - who is inbound
 - who is currently here
 - who wants to leave

# Models

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
  - location
 - belongsTo
  - ActualTrips
 - calculates
  - availableSeats
 - does
  - acceptReservation reservation, seats
  - reRoute      destination
  - departed     time
  - arrived      time

- Tourist
 - has
  - account  (name, email, auth, billing, etc)
  - notes   (used by support)
  - location is a Stop or Vehical
 - does
  - placeRequest destination, time, seats
  - cancelRequest
  - boardVehical time, seats
  - exitVehical  time, seats

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

# Attempting a diagram...

    {a, an} = require './def'

    a 'NamedAndDescribed'
      .has
        shortName   : String
        displayName : String
        desc        : String

    a 'Tourist', ->
      .is a 'NamedAndDescribed'
      .has
        email  : String
        notes  : String
        auth   : Object
        billing: Object
      .has a 'Request', ->
        .has Status 'requestStatus'
        .has Stop   'destination'
        .has Date   'departureTime'
        .has Number 'requestedSeats'
        .has guests: Number
        .has a 'RequestSolution', ->

    a 'Vehicle', ->
      .is a 'NamedAndDescribed'
      .has a 'Reservation', ->
        .belongsTo a 'Request'
        .has a 'SchedledTrip'
          .has a 'Trip', ->
            .has a 'Stop' 'from'
            .has a 'Stop' 'to'
          .has Date 'departureTime'

    
