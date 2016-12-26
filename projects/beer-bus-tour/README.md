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

- EventType extends NamedDescription

- ScheduledEvent
  - has
    - eventType
    - time

- ActualEvent
  - has
    - ScheduledEvent
    - actualTime

- ScheduledTrip _(needs a better name)_
  - has
    - ScheduledEvents depart, arrive

- Schedule
  - has
    - ScheduledTrips

- Journey
  - has
    - Vehicle
    - ScheduledTrip
    - ActualEvents depart, arrive
  - consumes TripLog

- BeerEventLog extends DB
  - has
    - BeerEvents
  - does
    - add
    - find

- Vehicle extends Location
  - has
    - capacity
    - passengerCount
  - does
    - addPassengers    count
    - removePassengers count
    - departFor        destination
    - arrive           destination

- Tourist extends NamedDescription
  - has
    - account (name, email, auth, billing, etc)
    - notes
    - Location
    - request

- Request
  - belongsTo Tourist
  - has
    - requestedStop
    - requestedTime
    - requestedSeats
