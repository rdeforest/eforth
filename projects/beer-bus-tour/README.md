# Beer bus tour

Tourists indicate interest in changing locations. Bus assignment based on
demand.

# Classes

- Location
  - has
    - name
    - description

- Stop extends Location
  - belongsTo
    - TourLegs

- TourLeg
  - has
    - from Stop
    - to   Stop

- Schedule
  - has
    - Trips

- Trip
  - has
    - TourLeg
    - departureTime
  - consumes TripLog
  - calculates
    - projectedDuration
    - projectedArrival

- TripLog
  - has
    - TripLogEntries

- TripLogEntry
  - has
    - Trip
    - departed
    - arrived

- Vehicle extends Location
  - has
    - TripLogEntry
    - capacity
    - remainingCapacity
  - calculates
    - progress
  - does
    - depart
    - arrive
    - passengersBoarded
    - passenversDeboarded

- Tourist
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
