module.exports = (Item) ->
  Item.prototype.due = ->
    not @acknowledged or (@acknowledged + @schedule().interval < Date.now())

  Item.prototype.acknowledge = (cb) ->
    @acknowledged = Date.now()
    @save()
    cb null

  Item.remoteMethod 'acknowledge',
    isStatic: false
    description: 'Snooze an item'
