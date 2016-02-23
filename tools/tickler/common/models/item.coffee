module.exports = (Item) ->
  Item.prototype.due = (at = Date.now()) ->
    not @acknowledged or @acknowledged + @schedule.interval < at

  Item.prototype.acknowledge = (at = Date.now()) ->
    @acknowledged = at
    @save()

  Item.remoteMethod 'acknowledge',
    isStatic: false
    accepts: [
        arg: 'id'
        type: 'number'
        required: true
      ]
    http:
      verb: 'post'
