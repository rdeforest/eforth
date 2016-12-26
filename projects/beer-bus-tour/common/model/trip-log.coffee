Trip = require './trip-log-entry'
DB   = require './db'

class TripLog extends DB
  constructor: ->
    super

    @createOrMigrateTable
      trip:
        schema:  Trip.schema
        migrate: Trip.upgradeStorage

  add: (trip) -> super 'trip', trip

  # DB::find filter

module.exports = new TripLog
