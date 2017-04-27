readline = require 'readline'

class ReadingSeasonUI
  constructor: ({@input, @output, @options = {}, CommandHandler}) ->
    @context = []
    @handler = new CommandHandler @, @options

    Object.assign @options, {@input, @output}

    if 'function' is typeof @handler.completer
      @options.completer = @handler.completer.bind @handler

    @rl = readline.createInterface @options

    @rl.on 'line', (line) =>
      @handler.processCommand line

  addContext: (context) ->
    @context.push context
    @updatePrompt()

  popContext: ->
    @context.pop()
    @updatePrompt()

  resetContext: ->
    @context = []
    @updatePrompt()

Object.assign module.exports, { ReadingSeasonUI }

