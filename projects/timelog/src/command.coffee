process = require 'process'
path    = require 'path'
fs      = require 'fs'

module.exports =
  Command: class Command
    constructor: (argvInfo) ->
      {action = 'help'} = argvInfo

      if not @action = Command.actions[action]
        throw new Error "Unknown action name '#{action}'"

    @identify: (argv = process.argv) ->
      argvInfo = Command.examineArgv argv

      new Command argvInfo

    @examineArgv: (argv) ->
      action = null
      remaining = []

      for arg, idx in argv
        switch
          when arg.startsWith '-'
            Command.examineSwitch arg, idx, argv

          when arg in ['am', 'was']
            action = arg

          else
            remaining.push arg

      return {action, remaining, argv}

    @examineSwitch: (arg, idx, argv) ->
      arg = argv[idx]
      skip = 0

      unless matched = arg.match /^(--*)(.*?)(=(.*))?/
        throw new Error "BUG"

      [found, dashes, switchStr, extra] = matched
      dashes = dashes.length

      swtch = Command.switches[switchStr]

      return Object.assign {}, swtch, dashes, switchStr, extra

    @switches:
      help:
        action: 'help'

    @actions:
      help:
        exec: (info = {}) ->
          {echo = console.log} = info
          echo 'this help is super useful'

      did: # persist an activity change
        exec: (info = {}) ->
        wants: argv: ({remaining}) -> remaining.length > 0

      doing: # persist an activity change
        exec: (info = {}) ->
        wants: argv: ({remaining}) -> remaining.length > 0

Command.actions.am  = Command.actions.doing
Command.actions.was = Command.actions.did
