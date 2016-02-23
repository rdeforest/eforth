module.exports = (app) ->
  app.datasources.db.isActual (err, actual) ->
    if not actual
      app.datasources.db.autoupdate()
