# core lib is responsible for persistence

class CoreObject
  constructor: (info) ->
    { @id
      @core
    } = info

class Core
  constructor: (frozenIterator) ->
    @dbTop = 0
    @initMinimal()

    if frozenIterator
      @load frozenIterator

  initMinimal: ->
    sys  = @create {}
    root = @create {}

    @chparent sys, root

  create: (info = {}) ->
    o = new CoreObject Object.assign info, id: @dbTop++, core: @
