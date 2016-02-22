module.exports = (Item) ->
  Item.prototype.due = (at = Date.now()) ->
    not @acknowledged or @acknowledged + @schedule.interval < at

  Item.prototype.acknowledge = (at = Date.now()) ->
    @acknowledged = at

  Item.remoteMethod 'acknowledge',
    accepts: [
        arg: 'id'
        type: 'number'
        required: true
      ]
    http:
      path: '/:id/acknowledge'
      verb: 'get'

