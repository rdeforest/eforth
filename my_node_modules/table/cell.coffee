if 'function' isnt typeof define
  define = require('amdefine')(module)

dimensionDescriptor = (dim, value) ->
  value: value
  set: (d) ->
    if this[dim] isnt d
      this[dim].cellLeaving this
      this[dim] = d

    this[dim].cellEntering this

define  [],
        () ->

  class Cell
    constructor: (info) ->
      Object.defineProperties this,
        d =
          v:
            value: info.v
            get: => @eval()
            set: (v) =>
              d.v = v
              @update v
          r: dimensionDescriptor 'r', info.r
          c: dimensionDescriptor 'c', info.c
          f: info.f
          t: info.t

      @r = @r
      @c = @c

    eval: ->
      Object.getOwnPropertyDescriptor this, 'v'
        .value

    update: (v) ->
      @c.cellChanged this
      @r.cellChanged this

    format: (f) ->
      if not f
        return @f or @c.format or @r.format or @t.format or Cell.format

      @c.cellChanging this, format: [@f, f]
      @f = f

    render: (targetMedium) -> @format.render targetMedium, @v

    toString: -> @render 'string'

    width: -> @toString().width

    move: (r, c) ->
      @r.cellLeaving this
      @c.cellLeaving this
      @r = @t.row r
      @c = @t.col c


  Cell.format = (medium, value) ->
    value.toString()

  Cell
