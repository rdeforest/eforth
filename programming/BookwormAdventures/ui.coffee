(require './shared') 'assert fs process readline'

mainMenu = null

Object.assign module.exports,
  menu: menu = (choices) ->
    new MenuMode

  mainMenu: (choices) ->
    mainMenu = menu choices

  wordMenu: ({getChoices}) ->
    new WordMenu

  choice: (fn) -> fn

  start: -> mainMenu.go()

partialRegex = (needle) ->
  partialExpr = (needle
    .split ''
    .join '('
  ) + ')?'.repeat needle.length - 1

  regex = new RegExp partialExpr

class Mode
  @comment: """
  """

  constructor: (info) ->
    { @title
      @choices = []
      @noMatch
    } = info

    assert.equal 'string', typeof @title

  prompt:       -> @makePrompt { @title, @choices, @noMatch, @namedChoices }
  noMatch:      -> "exit"

  makePrompt: (info) ->
    { title, choices, noMatch, namedChoices } = info

    if choices
      nameWidth = Math.max choices.map ({name}, i) ->
        name?.length or i.toString().length

      items = choices.map (s, i) -> (i + 1).padEnd(nameWidth) + ' ) ' + s

    items.push '*'.padEnd(nameWidth) + ' ) ' + 'exit'

    return "\n== #{title} ==\n  " + items.join '\n  '

  line:  (line) ->
    err =
      if @constructor is Mode
        "Mode is an abstract class"
      else
        "#{@constructor.name} must override ::line(data)"

    throw new Error err

class MenuMode extends Mode
  constructor: (info) ->
    super info

    assert.equal 'object', typeof @namedChoices

    @regexps =
      @namedChoices
        .map (word) -> [(partialRegex word), word]

  do: (command, line) ->
    unless 'function' is typeof @[command]
      throw new Error "#{@constructor.name} instance doesn't define an action for #{command}"

    @[command](command, line)

  line: (line) ->
    for [regex, word] of @namedChoices
      if regex.match line
        return @do word, line

    @unmatchedChoice line

  unmatchedChoice: (line) ->
    mode = modes.mainmenu

class AttackMenu extends MenuMode
  constructor: (info) ->
    super info

prevPage = -> choicesSkipped = (choices.length + choicesSkipped - choicesPerPage) % choices.length
nextPage = -> choicesSkipped = (choices.length + choicesSkipped + choicesPerPage) % choices.length
rangeError = (n, min, max) -> rl.write "#{n} is outside the range [#{min} .. #{max}]"

modes    =
  mainmenu:
    items: 'start options'.split(' ')
    prompt: -> makeMenuPrompt 'Main menu', , 'quit'
    regexps:
      start:   partialRegex 'start'
      options: partialRegex 'options'

    line: (line) ->
      { regexps } = modes.mainmenu

      switch
        when line.contains 1 or line.match regexps.start
          mode = modes.letters

        when line.contains 2 or line.match regexps.options
          mode = modes.options

        else process.exit()

  options:
    prompt: -> """
      Options menu:
        (no options exist yet)
        * ) Main menu
      > """

    line: (line) ->
      mode = modes.mainmenu

  wordmenu:
    prompt: ->
      currentPage = choices[choicesSkipped..choicesSkipped + choicesPerPage - 1]
      makeMenuPrompt 'Pick attack', currentPage, 'next page', '-': 'previous page'

    line: (line) ->
      if 'number' is n = parseInt line
        return
          switch
            when 1 <= n <= choicesPerPage
              prevPage()
            when n > choicesPerPage
              nextPage()
            else
              rangeError n, 1, choicesPerPage



  letters:
    line: (line) ->

(rl = readline.createInterface
  input: process.stdin
  output: process.stdout
).on 'line', (line) ->
  mode.line line.toString()

