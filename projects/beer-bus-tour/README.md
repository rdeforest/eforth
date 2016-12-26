# Beer bus tour

Tourists indicate interest in changing locations. Bus assignment based on
demand.

# Classes

- Location

- Stop extends Location
  - has
    - description
  - belongsTo
    - legs

- PathLeg
  - has
    - from Stop
    - to   Stop

- Schedule
  - has
    - Trips

- Trip
  - has
    - PathLeg
    - departureTime
  - consumes TripLog
  - calculates
    - projectedArrivalTime

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
    - Velocity, normalized relative to expected
    - Delay amount

- Tourist
  - has
    - account (name, email, auth, billing, etc)
    - notes
    - Location
    - requestedStop
    - requestedTime
    - requestedSeats
