DEFAULT_LEVEL_NAMES = 'debug info warn error fatal'.split ' '

module.exports =
  class Logger
    constructor: ({@stderr}) ->
      @level ''

    currentLevel: (newLevel) ->
      oldLevel = @level

      if 'string' is typeof newLevel
        if -1 isnt idx = levels.indexOf newLevel
          @level = idx
        else
          throw new Error "Unknown logging level '#{newLevel}'"

      return oldLevel

    log: (level, args...) ->
      if level >= @level
        @stderr.write util.format args...

for level, idx in DEFAULT_LEVEL_NAMES
  Logger::[level] = (args...) -> @log idx, args...
