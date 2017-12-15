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
  @comment: """
    Translate from input to request
  """

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

mapOneEntry = (obj, fn) ->
  unless ([k] = Object.keys(obj)).length is 1
    throw new Error "one command per 'c' please"

  fn k, obj[k]

c = (nameAndDesc, impl) ->
  mapOneEntry nameAndDesc,
    (name, desc) ->
      new Command name, desc, impl

commands = (patternsAndCommands) ->
  mapOneEntry patternsAndCommands,
    (pattern, command) ->
      new CommandPattern pattern, command

simpleCommands = (namesAndImpls) ->
  commands =
    Object
      .entries namesAndImpls
      .map (name, impl) -> "^#{name} ": new Command name, '', impl)...

  Object.assign {}, commands...

Object.assign exports, {
  Command, CommandMapping, CommandParser
  c,       commands,       simpleCommands
}
