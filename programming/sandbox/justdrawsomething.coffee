# How hard can it be to create a canvas and draw something on it?

session = null

$ -> session.start()

session =
  defaults:
    charWidth:  8, charHeight:  8
    textWidth: 80, textHeight: 25

  pixels: null

  resize: ->
    @canvas.width  '100%'
    @canvas.height '100%'

    @redraw()
    @

  redraw: ->
    @ctx.drawImage createImageBitmap(@pixels), 0, 0, resizeWidth: 
    @

  handler:
    break:    (event) -> # help or stop program or whatever
    enter:    (event) -> # execute current line, whatever that is
    other:    (event) ->

  makeBody:   -> @body   or $('body')
  makeCanvas: -> @canvas or $('<canvas>')

  clearText: ->
    @lines = [1..@textHeight].map -> [1..@textWidth].map -> ' '
    @

  homeCursor: ->
    @cursor = [0, 0]
    @

  recreateBuffer: ->
    @pixels = new ImageData @xPixels, @yPixels
    @

  start: ->
    @body
      .empty()
      .append @canvas
      .append          $('<br>'    )
      .append input  = $('<input>' )

    @body
      .css 'overflow', 'hidden'
      .css 'margin'  , '0'

    @ctx = @canvas.getContext '2d'

    @ .clearText()
      .homeCursor()
      .recreateBuffer()
      .resize()

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

Object.defineProperties session,
  xPixels:     get: -> @charWidth  * @textWidth
  yPixels:     get: -> @charHeight * @textWidth
  pixelWidth:  get: -> Math.min @canvas.width(), @canvas.height() * 4 / 3
  pixelWidth:  get: -> Math.min @canvas.width(), @canvas.height() * 4 / 3
