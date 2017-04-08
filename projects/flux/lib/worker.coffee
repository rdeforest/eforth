module.exports =
  class Worker
    constructor: (@dispatcher) ->
      @dispatcher.registerWorker (event) => @receiveEvent event

    destroy: ->
      @dispatcher.unregisterWorker @

    receiveEvent: (name, data) ->
      try
        @processEvent name, data
      catch e
        @emit "processingFailed", name, error: e, data: data, worker: @

    emit: (name, data) ->
      @dispatcher.send name, data

