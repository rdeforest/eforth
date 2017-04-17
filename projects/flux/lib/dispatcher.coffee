{Event} = require './event'

module.exports.Dispatcher =
  class Dispatcher
    constructor: ->
      @nextId       = 0
      @callbacks   = []
      @isPending   = {}
      @isHandled   = {}
      @dispatching = false

    isDispatching: -> @dispatching

    send: (name, data) ->
      @dispatch new Event @, name, data

    waitFor: (ids) ->
      if not @dispatching
        throw new Error "Can only ::waitFor during a dispatch in progress"

      for id in ids
        switch
          when not @callbacks[id]
            throw new Error "No such callback #{id}"
          when not @isPending[id]
            @dispatchTo id
          when not @isHandled[id]
            throw new Error "dependency loop waiting for #{id}"

    startDispatching: (@event) ->
      if @dispatching
        throw new Error "Multiple concurrent or nested dispatches not allowed"

      @isPending = {}
      @isHandled = {}

      @dispatching = true

    stopDispatching: ->
      if not @dispatching
        throw new Error "Dispatching ended twice?!"

      for id, state of @isPending when state
        throw new Error "#{id} still pending after dispatch?!"

      for id, state of @isHandled when not state
        throw new Error "#{id} netiher handled nor pending after dispatch?!"

      @dispatching = false

    dispatchTo: (id) ->
      @isPending[id] = true
      @callbacks[id] @event
      @isHandled[id] = true

    dispatch: (event) ->
      try
        @startDispatching event

        @dispatchTo id for id in @callbacks when not @isPending[id]
      finally
        @stopDispatching event

    register: (callback) ->
      @callbacks[id = @nextId++] = callback
      return id

    unregister: (id) ->
      @callbacks[id] = undefined
