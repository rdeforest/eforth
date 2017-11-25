{ Store } = require './store'

class MemStore extends Store
  constructor: ->
    super()
    @_ = {}

  get: (key) -> @_[key]

  put: (key, data) ->
    if @has key.toString()
      throw new Error "Cannot re-write record '#{key}'"

    @_[key] = data
    @

  has: (key) ->
    key in Object.keys @_


Object.defineProperties MemStore::,
  size:
    get: ->
      Object
        .keys @_
        .length

Object.assign module.exports, { MemStore }

