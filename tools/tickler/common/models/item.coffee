module.exports = (Item) ->
  Item.prototype.due = (at = Date.now()) ->
    return (@acknowledged or 0) + @schedule().interval < at

  Item.prototype.acknowledge = (at = Date.now()) ->
    @acknowledged = at
    @save()
    return this
