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
- VehicleController
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
- TouristController
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

# Controllers

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

      has: (propName, model) ->
        @hasRelations[propName] = model
        model.belongsTo @

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
        shortName  : String
        displayName: String
        desc       : String

    a 'Tourist', ->
      .is a NamedAndDescribed
      .hasProps
        name   : String
        email  : String
        notes  : String
        auth   : Object
        billing: Object
      .has a 'Request', ->
        .has Status 'requestStatus'
        .has Stop   'destination'
        .has Date   'departureTime'
        .has Number 'requestedSeats'

    a 'Reservation', ->
      .has a 'Request'
      .has a 'Trip', ->

    a 'Vehicle', ->
      .has a 'Reservation', ->
        .has a 'SchedledTrip'
          .has a 'Trip', ->
            .has a 'Stop' 'from'
            .has a 'Stop' 'to'
          .has Date 'departureTime'

    
