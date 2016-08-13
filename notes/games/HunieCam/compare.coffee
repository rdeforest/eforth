# Compare photo vs cam decisions

class Path
  constructor: (state) ->
    { @time        =  0
      @photoVisits =  0
      @camVisits   =  0
      @stress      =  0
      @fans        = 10
      @money       =  0
      @skill       =  1
      @style       =  1
    } = state

  photoFans:     -> @style * (@style + 4)
  photoDuration: -> Math.min 32, @photoVisits >> 1
  camMoney:      -> Math.floor @fans * (@skill + 1) / 4
  camDuration:   -> Math.min 48, @photoVisits >> 1
  wage:          -> 2**(@skill + @style - 2)
