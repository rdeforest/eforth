{Change} = require './change'

class Event
  @DISPATCHED : Symbol 'Event.DISPATCHED'
  @PENDING    : Symbol 'Event.PENDING'
  @ACCEPTED   : Symbol 'Event.ACCEPTED'
  @REJECTED   : Symbol 'Event.REJECTED'

  constructor: (info = {}) ->
    { @name
      @parent
      @receiver
      @details = {}
      @origin  = @parent?.receiver
    } = info

    @changes   = []
    @status    = null
    @readyWhen = []
    @addChange = Change.factory @receiver.worlds,
      (fn, ready) ->
      @changes.push 

  _result: (r) ->
    if @status isnt Event.REJECTED
       @status   =  r

  accept: (changes = []) -> # destination     happy
    if @_result Event.ACCEPTED
      @changes = @changes.concat changes

  reject: (message)  -> # destination not happy
    @childFailed @, message

  spawn: (@details) ->
    recipients = @receiver.listeners

  ready: ->
    (@readyWhen =
      @readyWhen
        .filter (fn) -> not fn()).length is 0

  wait: (readyFn) ->
    @readyWhen.push readyFn
    @status = Event.PENDING

  dispatch: ->
    @receiver.receiveEvent @

    if @status is Event.DISPATCHED
      throw new Error "Dispatch error: receiver (#{@receiver.name}) didn't accept, reject or wait"

    @status

  childFailed: (child) ->
    @status = Event.REJECTED
    @parent?.childFailed child

class Event.Tick extends Event

module.exports = {Event}
