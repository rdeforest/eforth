# How hard can it be to create a canvas and draw something on it?

root =
  switch
    when 'undefined' isnt typeof global then global
    when 'undefined' isnt typeof window then window
    else throw new Error 'wtf is root round these parts?'

class Session
  constructor: (info = {}) ->
    @canvas  = $('<canvas>')
    @ctx     = @canvas[0].getContext '2d'

    (@[k] = info[k] or v) for k, v of Session.defaults

    @body
      .empty()
      .append @canvas
      .append          $('<br>'    )
      .append input  = $('<input>' )
      .css 'overflow', 'hidden'
      .css 'margin'  , '0'

    @ .clearText()
      .homeCursor()
      .recreateBuffer()
      .resize()

    console.log "canvas is #{@xPixels} x #{@yPixels}"

    @body.resize -> resize canvas, input

    @body
      .keypress (event) ->
        handlerName =
          switch event.which
            when 13 then 'enter'
            when 27 then 'escape'
            when 32 then 'space'
            when  3 then 'break'
            else         'other'

        handler[handlerName] event

    @greeting()

  greeting: ->
    background = "rgb(0,   0, 255)"
    foreground = "rgb(0, 255, 255)"

    @clearText()
    @emitLine "Welcome to SandBox!"

  emitLine: (line) ->
    @insertLineAboveCursor line

  insertLineAboveCursor: (line) ->
    insertLineAbove @cursor
    @row[@cursor[1]][..line.length - 1] = line.split ''
    @moveCursor 0, 1

  moveCursor: (dx, dy) ->
    @cursor = [@cursor[0] + dx, @cursor[1] + dy]

  @defaults:
    charWidth:   8, charHeight:  8
    textWidth: 160, textHeight: 50

  pixels: null

  resize: ->
    @canvas.width  '100%'
    @canvas.height '100%'

    @redraw()
    @

  redraw: ->
    createImageBitmap @pixels, resizeWidth: @canvasWidth, resizeHeight: @canvasHeight
      .then (bmp) =>
        console.log 'bmp constructor: ' + bmp.constructor.name
        @ctx.drawImage bmp, 0, 0

  handler:
    break: (event) -> # help or stop program or whatever
    enter: (event) -> # execute current line, whatever that is
    other: (event) ->

  clearText: ->
    @lines = [1..@textHeight].map => [1..@textWidth].map -> ' '
    @

  homeCursor: ->
    @cursor = [0, 0]
    @

  recreateBuffer: ->
    @pixels = new ImageData @xPixels, @yPixels
    @

Object.defineProperties Session::,
  xPixels:      get: -> @charWidth  * @textWidth
  yPixels:      get: -> @charHeight * @textWidth

  canvasWidth:  get: -> Math.min @canvas.width(),  @canvas.height() * 4 / 3
  canvasHeight: get: -> Math.min @canvas.height(), @canvas.width()  * 3 / 4

  body:         get: -> $(document.body)

$ ->
  root.rdf = new Session

