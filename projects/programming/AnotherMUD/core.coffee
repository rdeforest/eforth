# core lib is responsible for persistence

{ CoreObject } = require './core-object'

class Core
  constructor: (frozenIterator, @store) ->
    @dbTop = 0
    @initMinimal()
    @db = []

    @load frozenIterator if frozenIterator

  initMinimal: ->
    sys  = @create {}
    root = @create {}

    @chparent sys, root

  create: (info = {}) ->
    @db[id] = new CoreObject {info, id, core: @}
    id = @dbTop++
    @

  chparent: (child, parent) ->

  startHypothetical: (target, message, args) ->

    
