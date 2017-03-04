_ = require 'lodash'
curry = require 'lodash/curry'

class Maybe
  constructor: (@__value) ->

  @of: (x) -> new Maybe x

  isNothing: -> @__value in [null, undefined]

  map: (f) -> if @isNothing then Maybe.of null else Maybe.of f @__value

map = curry (f, functor) -> functor.map f

maybe = curry (x, f, m) -> if m.isNothing then x else f m.__value

prop = _.property

class Left
  constructor: (@__value) ->
  @of: (x) -> new Left x
  map: (f) -> @

class Right
  constructor: (@__value) ->
  @of: (x) -> new Right x
  map: (f) -> Right.of f @__value

getAge = curry (now, user) ->
  birthdate = moment user.birthdate, 'YYYY-MM-DD'
  if not birthdate.isValid()
    Left.of 'Invalid birthdate'
  else
    Right.of now.diff birthdate, 'years'

fortune = compose concat(), add 1

Object.assign global, {Maybe, Left, Right, map, maybe, curry, prop, _, getAge}
