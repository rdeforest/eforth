module.exports = (Participant) ->
  Participant.prototype.pendingMessages = ->
    @items.filter (i) -> i.due()

  Participant.remoteMethod 'pendingMessages',
    isStatic: false
    accepts: [
        arg: 'id'
        type: 'number'
        required: true
      ]
    returns: arg: 'items', type: 'array'
    http:
      path: '/participants/:id/pendingMessages'
      verb: 'get'
