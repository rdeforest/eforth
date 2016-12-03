try
  { stdin, stdout, stderr, argv } = require 'process'

  Logger   = require './log'
  Action   = require './action'

  log      = new Logger { stderr }
  action   = new Action { argv }

  action.start()

catch e
  log "Last-chance error handler caught this:\n\n" + util.format e
