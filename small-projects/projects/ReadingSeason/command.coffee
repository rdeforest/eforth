class CommandHandler
  constructor: (@ui, @options = {}) ->

  processCommand: (input) ->
    matches = @matchCommand input

  commands: {}

  matchCommand: (input) ->
    matches = prefix: [], proximate: []
    [firstWord, rest...] = input.match /(\S+)/g

    for cmdInfo in @commands
      match = cmdInfo.match input, firstWord, rest

      if match.exact
        return cmdInfo

      if match.prefix
        matches.prefix.push cmdInfo
        continue

      if match.proximate
