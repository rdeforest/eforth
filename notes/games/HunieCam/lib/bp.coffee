###

Usage:

  libs =
    Backbone: "backbone"
    config: "./config"

  (require './bp') libs, (libs) ->
    {config, Backbone} = libs

###

module.exports = (libs, fn) ->
  for name, path of libs
    if 'string' is typeof path
      libs[name] = require path

  fn libs
