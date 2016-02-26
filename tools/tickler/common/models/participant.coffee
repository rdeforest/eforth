module.exports = (Participant) ->
  Participant.prototype.pendingMessages = (cb) ->
    cb null, @items().filter (i) -> i.due()

  Participant.remoteMethod 'pendingMessages',
    isStatic: false
    returns:
      arg: 'items'
      type: 'array'
