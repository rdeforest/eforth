{ c, commands, simpleCommands } = require './commandParser'

helpOn = (inputEvent) ->

simple = simpleCommands
  help: (input) -> (UI) -> UI.respondTo inputEvent, helpOn inputEvent
  exit: exit = -> (UI) -> UI.exit 0
  quit: exit

fancy = commands
  "^d (\S+?)((\.|::).*)?": c display: "display an object and (optionally) it's members",
    (inputEvent) -> display inputEvent

module.exports = [simple..., fancy...]

