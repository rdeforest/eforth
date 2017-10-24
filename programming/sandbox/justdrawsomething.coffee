# How hard can it be to create a canvas and draw something on it?

root =
  switch
    when 'undefined' isnt typeof global then global
    when 'undefined' isnt typeof window then window
    else throw new Error 'wtf is root round these parts?'

class Session
  constructor: (info = {}) ->
    @settings = Object.assign {}, Session.defaults

    @canvas  = $('<canvas>')
    @ctx     = @canvas[0].getContext '2d'

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

  @defaults:
    name: 'main'
    pixels: null
    penInfo:
      x: 0, y: 0
      foreground: 'white'
      background: 'black'

    charWidth:   8, charHeight:  8
    textWidth: 160, textHeight: 50

  everyTick: (tickNum) ->

  pen: (cmdAndArg) ->
    for cmd, value of cmdAndArg
      switch cmd
        when 'color'
          @pen foreground: value[0]
          @pen background: value[1]

        when 'foreground', 'background', 'x', 'y'
          @penInfo[cmd] = value
          @penInfo = @penInfo # trigger persistence

  ops: {}
  greeting: ->
    @pen colors: ["blue", "cyan"]
    @clearText()
    @emitLines "Welcome to SandBox!", ""

  emitLines: (lines...) -> @emitLine line for line in lines

  emitLine: (line) ->
    @insertLineAtCursor line

  insertLineAtCursor: (line) ->
    insertLineAt @cursor
    @emit line
    @moveCursor 0, 1

  emit: (text) ->
    @row[@cursor[1]][..line.length - 1] = line.split ''
    @cursor[0] += line.length

  moveCursor: (dx, dy) ->
    @cursor = [@cursor[0] + dx, @cursor[1] + dy]

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

  restore: (type) ->
    key = @[type + "Key"]
    @settings = JSON.parse localStorage.getItem key

  update: (type) ->
    key = @[type + "Key"]
    localStorage.setItem key, JSON.stringify @settings

Object.defineProperties Session::,
  xPixels:      get: -> @charWidth  * @textWidth
  yPixels:      get: -> @charHeight * @textWidth

  canvasWidth:  get: -> Math.min @canvas.width(),  @canvas.height() * 4 / 3
  canvasHeight: get: -> Math.min @canvas.height(), @canvas.width()  * 3 / 4

  body:         get: -> $(document.body)

  saveKey:      get: -> "#{@constructor.name}_save_#{@name}"
  liveKey:      get: -> "#{@constructor.name}_live_#{@name}"

for k of Session.defaults
  Object.defineProperty Session::, k,
    get: -> @settings[k]
    set: (v) ->
      @settings[k] = v
      @update 'live'

typeListCheck = (typeInfo) ->
  checks = typeInfo.map (type) -> typeNameCheck type

  (arg) ->
    for check in checks
      {err, value} = checked = check args[idx]

      return checked unless err

hexToColor = (hex) ->
  if hex.length in [3, 4]
    hex =
      hex.split ''
         .map (d) -> d + d
         .join ''

parseColor = (cStr) ->
  return value if value = Session.namedColors[cStr]

  if matched = cStr.match /^#([0-9a-f]{3,8})$/
    if matched[1].length in [5, 7]
      err: 'hex colors must be 3, 4, 6 or 8 digits long'
    else
      value: hexToColor matched[1]
  else
    error: 'color not recognized'

  #if matched = cStr.match /^rgb(a?)\(([ 0-9,]*)\)$/
  #  nums = matched[2].split ///\s*,\s*///

typeNameCheck = (typeName) ->
  switch typeName
    when 'any', 'string'  then (x) -> {value: x}
    when 'color'          then parseColor
    when 'number'
      (x) ->
        return {value: n} if (n = parseInt x) or (n is 0)
        return {err: 'not a number'}

makeCheck = (typeInfo) ->
  if Array.isArray typeInfo
    return typeListCheck typeInfo

  typeNameCheck

makeValidator = (params) ->
  checkers = []

  for p in params
    switch typeof p
      when 'string'
        checkers.push makeCheck p

      when 'object'
        for pName, pInfo of p
          checkers.push makeCheck pInfo

makeOps = (namesAndDefs) ->
  for name, def of namesAndDefs
    {params = [], impl} = def

    Session::ops[name] = (args...) ->
      if valid = validateArgs params, args
        impl valid
      else
        error

makeOps
  background: args: [ 'color' ], impl: (color) -> @pen background: color
  foreground: args: [ 'color' ], impl: (color) -> @pen foreground: color

  colors:
    args: [ foreground: 'color', background: 'color' ]
    impl: (foreground, background) ->
      Object.assign @pen, {foreground, background}

  clear: impl: -> @clear()
  reset: impl: -> @reset()

$ ->
  root.rdf = new Session
