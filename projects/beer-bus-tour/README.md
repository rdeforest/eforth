# Beer bus tour

Tourists indicate interest in changing locations. Bus assignment based on
demand.

# Classes

- NamedDescription extends Persisted
  - has
    - name
    - description

- Location extends NamedDescription

- Stop extends Location
  - belongsTo
    - TourLegs
  - does
    - getConnectedStops

- BeerEventDescription extends NamedDescription

- VehicalEventDescription extends BeerEventDescription
  - has
    - vehical
    - from
    - to
    - change in departed, arrived, re-routed

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

- Vehicle extends Location
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

- Tourist extends NamedDescription
  - has
    - account   (name, email, auth, billing, etc)
    - notes     (used by support)
    - Location
    - request
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
