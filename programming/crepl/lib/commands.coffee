{ c, commands, simpleCommands } = require './commandParser'

helpOn = (input) ->

module.exports = (UI) ->
  cmd =
    simpleCommands
      help: (input) ->
        UI.response input, helpOn input

