R = require 'ramda'

class Axis
  constructor: (@table) ->
    @members = []
    @minIdx  =
    @maxIdx  = null
    @cursor  = null

  axisName: -> @constructor.name

  extend: (idx) ->
    if @minIdx is null
      return @minIdx = @maxIdx = idx
    
    if idx < @minIdx
      for i in [idx .. @minIdx]
        @members[i] = new @constructor.memberClass

  exists: (idx) ->

class AxisMember extends Formatted
  constructor: (@axis) ->
    @cells = new Set

(class Rows    extends Axis).memberClass = class Row     extends AxisMember
(class Sheets  extends Axis).memberClass = class Sheet   extends AxisMember
(class Columns extends Axis).memberClass = class Column  extends AxisMember

module.exports.Table =
class Table
  constructor: ->
    @axes = [ new Sheets  @
              new Columns @
              new Rows    @ ]

    [sheets, columns, rows] = @axes
    Object.assign @axes, sheets, columns, rows

    @cells = new Set

  selectAxisMember: (axisName, index) ->
    @axes[axisName].select index

  selectCell: (coordinates...) ->
    areNumbers = (n) ->
      'number' is typeof n or
      n instanceof Number

    if R.all areNumbers, coordinates
      if (got = coordinates.length) isnt (needed = @axes.length)
        throw new Error "Cannot address cell with #{got} numeric indexes, need exactly #{needed}"

      coordinates.forEach (n, i) ->
        @axes[i].select n
    else if 'object' is typeof indexes = coordinates[0]
      for axis, index of indexex
        @axes[axis].select index
    else
      methodStr = (JSON.stringify coordinates)[1..-2]

      methodStr = methodStr[..27] + "..." if methodStr.length > 30

      throw new Error "Indexes provided (#{methodStr}) not recognized. Expected single object or multiple numbers"
