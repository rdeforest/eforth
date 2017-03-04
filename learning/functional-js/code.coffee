curry = require 'lodash/curry'

MakerMaker = (ctor, proto) ->
  Object.create proto, Object.assign, {}, ctor, of: (x) ->
    Object.create

class MetaContainer
  constructor: (name, maker) ->
    made = Object.assign {}, maker

    made.of = (x) -> Object.create

    return made

Container =
  new MetaContainer class
    constructor: (x) ->
      @__value = x

    map: (f) -> @constructor.of f @__value

class Maybe extends Container
  @of: (x) -> new Maybe x

  isNothing: -> @__value in [null, undefined]

  map: (f) -> if @isNothing then Maybe.of null else Maybe.of f @__value

map = curry (f, functor) -> functor.map f

maybe = curry (x, f, m) -> if m.isNothing then x else f m.__value

Either = Container

class Left extends Either
  map: -> @

class Right extends Either


Object.assign global, {Container, Maybe, Either, Left, Right}
