module.exports = (Participant) ->
  Participant.prototype.pendingMessages = ->
    now = Date.now()

    @items.filter (i) ->
      i.schedule.next i < now
