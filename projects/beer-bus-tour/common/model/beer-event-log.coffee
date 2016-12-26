BeerEvent = require './beer-event'
DB        = require './db'

class BeerEventLog extends DB
  constructor: ->
    super
    @createOrMigrateTable BeerEvent

  add: (event) -> super 'event', event

module.exports = new BeerEventLog
