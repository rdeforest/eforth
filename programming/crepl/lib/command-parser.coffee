class CommandParser
  constructor: (commands) ->
    @commands = []
    @matchers = []

    @addCommands commands

  addCommands: (commands) ->
    @addCommand command for command in commands

  addCommand: (command) ->


