# Having a go at Bruce's design interview question:
# "Design a parking garage"

# Assumptions:
#   Garage is automated. Customers pull their vehicles onto an appropriately
#   sized platform which is retrieved by a robot and moved to an available
#   stall.
#
#   Customers are charged based on the size of platform they pull onto. They
#   are welcome to park a motorcycle on a large platform and will be charged
#   accordingly.

# Feature:
#   Spaces are filled smallest first; larger spaces will be used to store
#   smaller vehicles when necessary and possible.
#
# Capacity reporting:
#   The capacity report does not take the compaction above into account. It
#   only displays a count of completely enpty spaces of each shape.

# 'quote words, like in Perl'
qw = (s) -> s.split / +/g

class ParkingSpace
  constructor: (@shape, @contents) ->

  hasRoomFor: (vehicleShape) ->
    not @contents and
    vehicleShape.width  <= @shape.width and
    vehicleShape.height <= @shape.height

  accept: (vehicle) ->
    if @hasRoomFor vehicle.shape
      @contents = vehicle

  isEmpty: not @contents

class ParkingSpaceShape
  constructor: (@desc, @width, @length) ->

class Vehicle
  constructor: (@shape, @doing = VehicleActivity.arriving) ->

class VehicleShape
  constructor: (@desc, @widthFeet, @lengthFeet) ->

class VehicleActivity
  constructor: (@name) ->

for name in qw 'arriving parking parked leaving'
  VehicleActivity[name] = new VehicleActivity name

class Garage
  constructor: ->
    @spacesByShape = new Map

  addSpace: (parkingSpace) ->
    {shape} = parkingSpace.shape

    @spacesByShape.set shape, [] unless @spacesByShape.has shape

    @spacesByShape
      .get  shape
      .push parkingSpace

    @ # support chained calls

  getEmptySpaces: ->
    Object.assign {},
      ( for shape in VehicleShape.shapes
          spaces = @spacesByShape.get shape
          "#{shape.name}": spaces.filter (space) -> space.isEmpty()
      )...

  getAvailability: ->
    avail = {}

    avail

  addVehicle: (vehicle) ->
    

