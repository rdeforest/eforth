class Event
  @REJECTED   : Symbol 'Event.REJECTED'
  @ACCEPTED   : Symbol 'Event.ACCEPTED'
  @PENDING    : Symbol 'Event.PENDING'
  @DISPATCHED : Symbol 'Event.DISPATCHED'

  constructor: (@parent, @origin, @receiver, @details = {}) ->
    @changes = []
    @status = null
    @readyWhen = []

  accept: (changes = []) -> # destination     happy
    if @status isnt Event.REJECTED
      @status = Event.ACCEPTED

    @changes = @changes.concat changes

  reject: (message)  -> # destination not happy
    @childFailed @, message

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
