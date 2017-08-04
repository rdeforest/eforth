# Solving Bruce's flood-fill interview question

# Given a matrix, a starting location and a fill color,
# change all pixels of the same color as the origin with the fill color.

class FloodFiller
  @directions: [
      {x:  1, y:  1} # SE (using 'screen' axes rather than standard
      {x: -1, y:  1} # SW  cartesian axes because 'flood fill' implies
      {x: -1, y: -1} # NW  a screen graphic operation)
      {x:  1, y: -1} # NE
    ]

  constructor: (@matrix, ox, oy, @originalColor, @fillColor) ->
    if @matrix instanceof FloodFiller
      @direction = x
      { @matrix, x, y, @originalColor, @fillColor } = @matrix
      @o = {x, y} # 'o' for 'origin' because we use this field a lot

    else if not Array.isArray(@matrix) and
                ((@height = @matrix.length   ) > 0) and
                ((@width  = @matrix[0].length) > 0) and
                -1 is (@matrix.findIndex (row) ->
                          row.length isnt @matrix[0].length)

        throw new Error "Argument to #{@constructor.name} constructor is not a rectangular matrix"

    unless 0 <= @o.x <= @width and 0 <= @o.y <= @height
      throw new Error "Origin (#{@o.x},#{@o.y}) out of bounds (0,0..#{@width},#{@height})"

    if @fillColor is @originalColor ?= @get matrix, x, y
      throw new Error "BUG: destination already painted"

  fill: ->
    if not @direction
      FloodFiller.directions.map (dir) ->
        (new FloodFiller @, dir)
          .fill()
      return

    limit = x: 0, y: 0
    limit.x = @width - 1 if dir.dx > 0
    limit.y = @width - 1 if dir.dy > 0

    area = []

    xRange = [@o.x .. xLimit]
    yRange = [@o.y .. yLimit]

    for x in xRange
      for y in yRange
        c = @get x, y

        if c isnt @originColor
          area.push
            x: @o.x .. x - dir.dx
            y: y


  @fill: (matrix, x, y, fillColor) ->
    (new FloodFiller matrix, x, y, undefined, fillColor)
      .fill()

    matrix

directions = [
  {dx:  1, dy:  0}
  {dx:  0, dy:  1}
  {dx: -1, dy:  0}
  {dx:  0, dy: -1}
].map (d, i) -> d.flags = 2 << i; d

floodFill = (matrix, originX, originY, fillColor) ->
  get = (x, y) -> matrix[y]?[x]
  put = (x, y) -> matrix[y][x] = fillColor

  return unless height = matrix.length and
                width  = matrix[0].length and
                'number' is typeof originColor = get originX, originY

  pending = [{x: originX, y: originY, dirMask: 0xF}]

  while pending.length
    {x, y, dirMask} = pending.pop()
    put x, y

    for dir in directions when dirMask & dir.flag
      {dx, dy} = dir

      if dx
        (put x, y) while originColor is get x += dx, y
      else
        (put x, y) while originColor is get x += dx, y

      
