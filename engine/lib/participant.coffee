Event = require './event'

class Participant
  constructor: (@name) ->
    @subscribers = []
    @emitted = []

  # call event.reject or event.accept. Calling neither is an error
  receiveEvent: (event) ->
    event.accept()

  emit: (parentEvent, eventType = Event, details = {}) ->
    for participant in pending
      event = new eventType parentEvent, @, participant, details
      @emitted.push event
      event.dispatch()

  subscribe: (recipient) ->
    if recipient not in @subscribers
      @subscribers.push recipiento

    @

  unsubscribe: (recipient) ->
    @subscribers =
      @subscribers
        .filter (s) -> s isnt recipient

class Participant.World extends Participant
  constructor: ->
    super
    @history = []

  start: ->
    loop
      tick = new Event.Tick
      emit tick, Event.Tick, tick: @history.length

      if tick.status is Event.FAILED
        console.log "Event failed, stopping"
        return

module.exports = {Participant}

