#{Event} = require './event'

module.exports.Dispatcher =
  class Dispatcher
    constructor: ->
      @nextId       = 0
      @callbacks   = []
      @isPending   = []
      @isHandled   = []
      @dispatching = false

    isDispatching: -> @dispatching

    send: (name, data) ->
      @dispatch {name, data} # new Event @, name, data

    waitFor: (ids) ->
      if not @dispatching
        throw new Error "Can only ::waitFor during a dispatch in progress"

      for id in ids
        switch
          when not @callbacks[id] then throw new Error "No such callback #{id}"
          when not @isPending[id] then @dispatchTo id
          when not @isHandled[id] then throw new Error "dependency loop waiting for #{id}"

    startDispatching: (event) ->
      if @dispatching
        throw new Error "Multiple concurrent or nested dispatches not allowed"

      @event = event

      @isPending = {}
      @isHandled = {}

      @dispatching = true

    stopDispatching: ->
      if not @dispatching
        throw new Error "Dispatching ended twice?!"

      for id, state of @isPending when state and not @isHandled[id]
        console.warn "#{id} still pending after dispatch?!"
        #throw new Error "#{id} still pending after dispatch?!"

      for id, state of @isHandled when not state
        console.warn "#{id} netiher handled nor pending after dispatch?!"
        #throw new Error "#{id} netiher handled nor pending after dispatch?!"

      @dispatching = false

    dispatchTo: (id) ->
      @isPending[id] = true

      if 'function' isnt typeof @callbacks[id]
        return console.warn "Unknown callback #{id}"
      else
        @callbacks[id] @event

      @isHandled[id] = true

    dispatch: (event) ->
      try
        @startDispatching event

        @dispatchTo id for fn, id in @callbacks when not @isPending[id]
      finally
        @stopDispatching event

    register: (callback) ->
      @callbacks[id = @nextId++] = callback
      return id

    unregister: (id) ->
      @callbacks[id] = undefined
