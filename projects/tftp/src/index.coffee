try
  process  = require 'process'
  dgram    = require 'dgram'

  { stdin, stdout, stderr, argv } = process
  { createSocket } = dgram

  Logger   = require './log'
  Action   = require './action'

  log      = new Logger { stderr }
  action   = new Action { argv }

  action.start()

  ###
  require './' + action.handler
  key      = action.key
  script   = process.argv[1]

  # Only provide what is required
  handlerArgs =
    switch action.handler
      when 'server' then { log, stdin, stdout      }
      when 'get'    then { log, stdin, stdout, key }
      when 'put'    then { log, stdin,         key }
      else               { script,     stdout      }

  handler handlerArgs
  ###

catch e
  log "Last-chance error handler caught this:\n\n" + util.format e
