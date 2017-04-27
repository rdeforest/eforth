class ReadingSeasonUI
  constructor: ({@input, @output, @options, @commandHandler}) ->
    @cli = readline.createInterface {@input, @output}

Object.assign module.exports, { ReadingSeasonUI }

