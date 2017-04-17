EventEmitter = require 'events'

module.exports.Worker =
  class Worker
    constructor: (@dispatcher, @changeEvent = 'change') ->
      @id = @dispatcher.register @receiveEvent.bind @
      @emitter = new EventEmitter
      @changed = false

    addListener: (callback) ->
      @emitter.on @changeEvent, callback

    emitChange: ->
      assert @dispatcher.isDispatching()

      @changed = true

    hasChanged: ->
      assert @dispatcher.isDispatching()

      @changed

    destroy: ->
      @dispatcher.unregisterWorker @

    receiveEvent: (event) ->
      {name, data} = event

      @changed = false
      @processEvent event

      if @changed
        @emitter.emit @changeEvent

module.exports.ReduceWorker =
  class ReduceWorker extends Worker
    constructor: (args...) ->
      super args...
      @state = @getInitialState()

    getInitialState: ->
      assert false, "abstract method not overriden"

    reduce: (state, event) ->
      eventName = event.name
      eventName[0] = eventName[0].toUpperCase()

      if handler = @[eventName]
        handler state, event
      else
        state

    areEqual: (a, b) -> a is b

    processEvent: (event) ->
      startingState = @state
      endingState = @reduce startingState, event

      unless @areEqual startingState, endingState
        @state = endingState
        @emitChange()
