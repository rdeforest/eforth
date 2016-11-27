invokedAsModule = false

module.exports = (injectedRequire = require) ->
  try
    require = injectedRequire
    invokedAsModule = true

    process = require 'process'
    dgram = require 'dgram'

    { stdin, stdout, stderr, argv } = process
    { createSocket } = dgram

    Logger   = require './log'
    Action   = require './action'

    log      = new Logger { stderr }
    action   = new Action { argv }

    new (require './' + action.handler) (
      # Only provide what is required
      switch action.handler
        when 'server'
          Session: require './session'
          log:     log

          Config:  require './config'
        when 'get'
          Session: require './session'
          log:     log

          key:     action.key
          stdin:   stdin
          stdin:   stdout
        when 'put'
          Session: require './session'
          log:     log

          key:     action.key
          stdin:   stdin
        else
          stdout:  stdout
          script:  process.argv[1]

  catch e
    log "Last-chance error handler caught this:\n\n" + util.format e

setImediate ->
  if not invokedAsModule
    module.exports()
