module.exports =
  class Logger
    constructor: ({@stderr}) ->

    log: (args...) ->
      @stderr.write util.format args...
