module.exports = function(app) {
    app.dataSources.db.isActual(function(err, actual){
      if (!actual) {
        app.dataSources.db.autoupdate();
      }
    });
  };
