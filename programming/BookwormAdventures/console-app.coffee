(require './shared') 'process',
  EventEmitter: 'events'

class App extends EventEmitter
  constructor: (info = {}) ->
    super arguments...
    { @mode } = info

  start: ->
    @emit 'starting'
    @mode.go()
    @emit 'started'

  enterMode: (mode = @startMode) ->
    if @mode
      @emit 'leaveing mode', mode
      @mode = mode
      @emit     'left mode', mode

    if mode
      @emit 'entering mode', mode
      @mode = mode
      @emit  'entered mode', mode
      @mode.go()
      return

    else
      @exit 1, "enterMode()"

  exit: (code = 0, reason) ->
    @emit 'exiting'
    console.log "Exiting: #{reason}" if reason
    process.exit code

Object.assign module.exports, { App }
