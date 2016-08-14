Tools for enhancing the coffee REPL to turn it into something else.

# Command

ui> foo
Foo says hi!
ui> foo 'thanks'
You're welcome!
ui>

    commands = {}

    addCommand = (name, info) ->
      { fn
        pattern = /^\s*#{name}(\s|$)/
        match   = (l) -> l.match @pattern
        help    = (l) -> "no help available"
      } = info

      commands[name] = {fn, pattern, matcher, help}

    addCommandModules = (modnames...) ->
      require addCommand for mod in modnames

    matchCommand = (line) ->
      firstWord = (line.trim().split /\s+/)[0]

      if cmd = commands[firstWord] and cmd.matcher line
        return found

      for name, cmd of commands
        if cmd.matcher line
          return found

    addCommand 'eval',
      pattern: /^(eval\s|;)(.*)/
      help: (l) -> "evaluate some CoffeeScript"
      fn: (line) ->
        code = line.match(@pattern)[2]

# Input processor

    inputProcessor = (line, context, filename, cb) ->

# Extending CoffeeScript REPL

    ui = require 'coffee-script/lib/coffee-script/repl'

    ui.start
      prompt: 'ui> '
      eval: inputProcessor
      ignoreUndefined: true
      writer: outputProcessor

