# Usage
#   Action
#     .fromArgv(process.argv)
#     .start()


module.exports =
  class Action
    start: ->
      @session = new @constructor.sessionClass this

    @sessionClass = Session.Help

    @fromArgv: (argv) ->
      [ coffee, script, action, key ] = argv

      return
        switch action
          when 'get'      then new Action.Get key
          when 'put'      then new Action.Put key
          when undefined  then new Action.Server
          else
            if action is 'help'
              new Help
            else
              new Help "The action '#{action}' was not recognized."

Object.assign Action,
  Get:    require './get'
  Put:    require './put'
  Help:   require './help'
  Server: require './server'
