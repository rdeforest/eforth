# Beer bus tour

Tourists indicate interest in changing locations. Bus assignment based on
demand.

# Classes

- Stop
  - belongsTo
    - TourLegs
  - does
    - getConnectedStops

- VehicalEventDescription
  - has
    - Vehical
    - Stop from
    - Stop to
    - change from [ requested, scheduled, departed, arrived, re-routed ]

- ScheduledEvent
  - has
    - eventType
    - time

- ActualBeerEvent
  - has
    - ScheduledEvent
    - actualTime

- ScheduledTrip
  - has
    - ScheduledEvents depart, arrive

- Schedule
  - has
    - ScheduledTrips

- ActualTrip
  - has
    - Vehicle
    - ScheduledTrip
    - ActualBeerEvents depart, arrive

- Vehicle
  - has
    - capacity
    - passengerCount
  - does
    - addPassengers    count
    - removePassengers count
    - setDestination   destination
    - reRoute          destination
    - depart
    - arriveAt

- Tourist
  - has
    - account   (name, email, auth, billing, etc)
    - notes     (used by support)
    - Stop|Vehical location
    - Request
  - does
    - placeRequest destination, time, seats
    - cancelRequest
    - board vehical
    - debark stop

- Request
  - belongsTo Tourist
  - has
    - requestedStop
    - requestedTime
    - requestedSeats
