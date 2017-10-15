words    = (fs.readFileSync '/usr/share/dict/words').toString().split '\n'
tiles    = []

{ App }  = require './console-app'

class WormApp extends App
  constructor: (info = require './ui')
    super arguments...

    @initUi info.ui

  initUi: (@ui) ->
    @ui.mainMenu
      start: @ui.wordMenu getChoices: => @attackChoices()
      exit:  @ui.choice (cmd, input) -> @exit()

  start: ->
    @ui.start()
