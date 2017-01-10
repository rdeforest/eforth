# User stories

## As a Tourist I want

- to know
 - where I can go on a single trip from 'here'
 - how long it will take to get to a given destination
 - what my current request is, if any
 - when I should expect to arrive at my destination
 - whether my announcements have been heard
  - and what is being done about them

- to announce
 - my transport didn't show
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
  - received passengers
  - delivered passengers
  - departed from a location
  - arrived at a location
  - encountered an exceptional circumstance

## As a Stop I want

- to say
 - what I have to offer
 - what transportation options are available
- to know
 - who is arriving
 - who is currently here
 - who is leaving

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

    class Model
      constructor: (modelName) ->
        # new Model 'ModelName'
        klass = Object.assign
        return cs.eval """
          class #{modelName} extends Model
            constructor: (propName) ->
        """

        # new ModelName 'referringPropName'
        if 'string' is typeof nameOrDescription
          return "#{nameOrDescription}": new @constructor

        # new ModelName ->
        if 'function' is typeof nameOrDescription
          if desc = nameOrDescription()
            return desc

        # Not creating a new Model and no name given, use default prop name
        # new ModelName
        name = @constructor.name
        name[0] = name[0].toLowerCase()

        return "#{name}": new @constructor

      hasProp: (name, info) ->

      hasProps: (propDicts...) ->
        for propDict in propDicts
          for name, info of propDict
            @hasProp name, info

      # 1:1
      has: (propName, model) ->
        @hasRelations[propName] = model
        model.belongsTo @

      # 1:n
      hasMany: (model) ->
        model.belongsTo @

      # n:1
      belongsTo: (model, propName = "#{model.name.toLowerCase}Id") ->
        @belongsToRelations[propName] = model

      is: (model) ->
        for key in [ 'hasProps', 'hasRelations', 'belongsToRelations' ]
          Object.assign @[key], model[key]

    a = an = (name, desc) ->
      if 'function' is typeof desc and models[name]
        throw new Error "Refusing to re-define '#{name}'"

      models[name] or= (args) ->
        if propName = args[0]
          "#{}": desc()
        else
          desc() or new Schema name

    a 'NamedAndDescribed', ->
      .hasProps
        shortName   : String
        displayName : String
        desc        : String

    a 'Tourist', ->
      .is a 'NamedAndDescribed'
      .hasProps
        email  : String
        notes  : String
        auth   : Object
        billing: Object
      .has a 'Request', ->
        .has Status 'requestStatus'
        .has Stop   'destination'
        .has Date   'departureTime'
        .has Number 'requestedSeats'

    a 'Vehicle', ->
      .is a 'NamedAndDescribed'
      .has a 'Reservation', ->
        .belongsTo a 'Request'
        .has a 'SchedledTrip'
          .has a 'Trip', ->
            .has a 'Stop' 'from'
            .has a 'Stop' 'to'
          .has Date 'departureTime'

    
