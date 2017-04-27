readline = require 'readline'
{stdin, stdout} = require 'process'

CommandHandler = require './command'

ui = new ReadingSeasonUI input: stdin, output: stdout, options: {}, commandHandler: CommandHandler

ui.start()
