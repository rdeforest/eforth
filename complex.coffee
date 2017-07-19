class Complex
  constructor: (r = 0, i = 0) ->
    if 'object' is typeof r
      if r instanceof Complex
        {@r, @i, @th, @mag} = Complex
      else if 'r' in keys = Object.keys r
        {@r, @i = 0} = r
      else if 'th' in keys
        {@th, @mag} = r
      else
        @r = @i = 0
    else
      {@r, @i} = {r, i}

  real: ->
    @deriveCart() if @r is undefined
    @r

  imag: ->
    @deriveCart() if @i is undefined
    @i

  theta: ->
    @derivePolar() if @th is undefined
    @th

  magnitude: ->
    @derivePolar() if @mag is undefined
    @mag

  deriveCart: ->
    if undefined in [@th, @mag]
      throw new Error "Cannot derive real and imaginary values: theta and/or magnitude are undefined"

    [@r, @i] =
      [ @mag * Math.cos(@th),
        @mag * Math.sin(@th) ]

  derivePolar: ->
    if undefined in [@r, @i]
      throw new Error "Cannot derive angle and magnitude: real and/or imaginary part are undefined"

    @mag = Math.sqrt(@r**2 + @i**2)
    @th  = Math.arctan

