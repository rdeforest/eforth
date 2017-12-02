uuidv1    = require 'uuid/v1'
{ Store } = require './store'

serialize = (persisted) ->
  unless persisted instanceof Persisted
    throw new Error "Can only serialize children of Persisted."

  klass  = persisted.constructor
  frozen = {}

  loop
    if frozen[klass.name]
      throw new Error "Multiple parents of object have same name, '#{klass.name}'"

    frozen[klass.name] = klass::freeze.call @

    break if klass is Persisted

  return JSON.stringify {
    __type: persisted.constructor.name
    frozen
  }

class Persisted
  constructor: ({@store, @uuid}) ->
    unless @store
      throw new Error "Cannot construct Persisted without a store."

    if @uuid
      return @store.get @uuid

  checkMutable: ->
    throw new Error "Cannot modify persisted objects." if @uuid

  commit: ->
    if @uuid
      throw new Error "Cannot re-write persisted objects."

    @store.put @uuid = uuidv1(), serialize @

  freeze: -> { @store, @uuid }

Object.assign module.exports, { Persisted }

