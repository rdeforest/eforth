# Usage
#   Action
#     .fromArgv(process.argv)
#     .start()

Key = require '../key'

module.exports =
  class Action
    constructor: (@argv = (require 'process').argv) ->

    start: ->
      (@session = new @constructor.sessionClass this)
        .start()

    @sessionClass = Session.Help

    @fromArgv: (argv = @argv) ->
      [ coffee, script, action, keyStr ] = argv

      return
        switch action
          when 'get'      then new Action.Get new Key keyStr
          when 'put'      then new Action.Put new Key keyStr
          when undefined  then new Action.Server
          else
            if action is 'help'
              new Action.Help
            else
              new Action.Help "The action '#{action}' was not recognized."

Object.assign Action,
  Get:    require './get'
  Put:    require './put'
  Help:   require './help'
  Server: require './server'
