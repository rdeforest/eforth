{TypeError} = require './errors'

class Command
  @makeCommand: (nameAndDesc, fn) ->
    for name, desc of nameAndDesc
      new Command name, desc, fn

  constructor: (@name, @desc, @fn) ->

  invoke: (args...) ->
    @fn args...

0 and
  Command.makeCommand
    example: 'does example stuff'
    (args...) -> # implementation

class CommandMapping
  constructor: (@pattern, @command) ->
    unless @command instanceof Command
      throw new TypeError @command, Command

    if 'string' is typeof @pattern
      @pattern = new RegExp @pattern

  match: (input) ->
    matched = input.match @pattern

class CommandParser
  constructor: (commandMappings) ->
    @commands = []
    @mappings = []

    @addCommandMappings commandMappings

  unknownCommandHandler: (input) ->
  addCommandMappings: (commandMappings) ->
    @addCommandMapping commandMapping for commandMapping in commandMappings
    return @

  addCommandMapping: (commandMapping) ->
    @mappings.push commandMapping
    @commands.push commandMapping.command
    return @

  matchCommand: (input) ->
    @mappings.find (m) -> m.match input

  handleInput: (input) ->
    if cmd = @matchCommand input
      cmd.invoke()

  makeCommands: (patternsAndCommands) ->
    for pattern, command of namesAndInfo
      @addCommandMapping new CommandMapping pattern, command

Object.assign exports, {Command, CommandMapping, CommandParser}
