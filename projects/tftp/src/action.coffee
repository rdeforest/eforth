# Usage
#   Action
#     .fromArgv(process.argv)
#     .start()


Session = require './session'
Server  = require './server'
Help    = require './help'

module.exports =
  class Action # law suit hahahaha :P
    constructor: (info = {}) -> {@key, @script} = info

    start: -> @session = new @constructor.sessionClass this

    @sessionClass = Session.Help

    @fromArgv: (argv) ->
      key = null

      [ coffee, script, action, key ] = argv

      switch action
        when 'get'      then handler = new Get key
        when 'put'      then handler = new Put key
        when undefined  then handler = new Server
        else                 handler = new Help script

      return handler

  class Get extends Action
    @sessionClass = Session.Read

  class Put extends Action
    @sessionClass = Session.Write

  class Help extends Action
    @sessionClass = Help

  class Server extends Action
    @sessionClass = Server

Object.assign Action, { Get, Put, Help, Server }

