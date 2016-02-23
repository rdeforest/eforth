module.exports = (Participant) ->
  Participant.prototype.pendingMessages = (cb) ->
    cb @items().filter (i) -> i.due()

  Participant.remoteMethod 'pendingMessages',
    isStatic: false
    accepts: [
        arg: 'id'
        type: 'number'
        required: true
      ]
    returns: arg: 'items', type: 'array'
    http: verb: 'get', path: '/pendingMessages'

  Participant.prototype.acknowledge = (itemId, cb) ->
    @items.findById itemId
      .then (item) ->
        item.acknowledge()

    cb null

  Participant.remoteMethod 'acknowledge',
    isStatic: false
    accepts: [
        arg: 'itemId'
        type: 'number'
        required: true
      ]
    http: verb: 'post', path: '/acknowledge'

