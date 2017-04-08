singleton = null

class Dispatcher
  constructor: ->
    unless singleton is null
      return singleton

    @nextId     = 0
    @callbacks  = {}
    @pending    = {}
    @dispatched = {}

  send: (name, data) ->
    @dispatch new Event @, name, data

  waitFor: (eventIds, callback) ->
    for eventId in eventIds
      (@waiters[eventId] ?= [])
        .push callback

  dispatch: (event) ->
    Promise.all(
      for w from @callbacks
        do (w, event) ->
          new Promise (resolve, reject) ->
            setImmediate ->
              try
                resolve w.receiveEvent event
              catch e
                reject e
    ).then ->
      @_updateWaiters event.id

  register: (callback) ->
    if @callbacks.has worker
      return @callbacks.get worker

    @callbacks.set worker, id = @nextId++
    id

  unregister: (worker) ->
    @callbacks.remove worker

  _updateWaiters: (eventId) ->
    if @waiters.has eventId
      for waiter in @waiters.get eventId
        (remaining = @waitingOn
          .get waiter)
          .delete eventId

        if 0 is remaining.size
          waiter()

module.exports = singleton = new Dispatcher
