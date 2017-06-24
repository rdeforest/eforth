module.exports =
  Change: class Change
    constructor: (info) ->
      { @realWorld
        @shadowWorld
        @event
        @fn
        @ready = {realWorld, shadowWorld} -> true
      } = info

    exec: ->
      @fn {@event, @realWorld, @shadowWorld}

    @factory: (defaults) ->
      (info) ->
        new @constructor Object.assign {}, defaults, info
