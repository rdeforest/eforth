request = require 'request'
htmlparser = require 'htmlparser2'

class TagHandler
  constructor: ({@onopentag = @_onopentag,
                 @ontext = @_ontext,
                 @onclosetag = @_onclosetag,
                 @warn = ->}) ->

    @stack = []
    @pending = {children: []}

  _onopentag: (name, attr) ->
    @stack.push @pending
    @children = []
    @pending = {name, attr, children: []}

  _ontext: (text) ->
    @pending.children.push text

  _onclosetag: (name) ->
    if name isnt @pending.name
      @warn 'Unexpected close tag'
        expected: @pending.name
        got: name

    if @stack
      completed = @pending
      @pending = @stack.pop
      @pending.push completed
    else
      @warn 'Stack underflow'

    if not @stack
      @done @pending

combosHandler = new TagHandler
  onclosetag: (name) ->
    if name is 'tr'
      processRow @pending
    @_onclosetag name

tagHandler = ->
  stack: []
  onopentag: ->
  ontext: ->
  onclosetag: ->

tableHandler =


htmlToDom = (html) ->
  handler =
    onopentag: (name, attributes) ->
      if name is table and attributes.id is ''
        delegate

    ontext: (text) ->
    onclosetag: (name) ->

  parser = htmlparser.Parser handler
  parser.write html
  parser.end()

parseWiki = (html) ->
  dom = htmlToDom html

module.exports = (Card) ->
  Card.getFromWiki = (url) ->
    new Promise (resolve, reject) ->
      request url, (err, resp, body) ->
        if err
          return reject err

        if resp.statusCode is 200
          cardData = parseWiki body

      
