# Compare photo vs cam decisions

class ChoicePoint
  constructor: (state) ->
    { @time         =  0
      @photoVisits  =  0
      @camVisits    =  0
      @stress       =  0
      @fans         = 10
      @money        =  0
      @skill        =  1
      @style        =  1
      @wagesPending =  0
    } = state

    @choices = ['photo', 'cam']
    @choices.push 'shopping'  if @style < 5
    @choices.push 'stripping' if @skill < 5

  photoFactor:   -> Math.min 64, @photoVisits
  photoFans:     -> @style * (@style + 4)
  photoDuration: -> Math.min 32, @photoVisits >> 1

  camFactor:     -> Math.min 96, @camVisits
  camMoney:      -> Math.floor @fans * (@skill + 1) / 4
  camDuration:   -> Math.min 48, @photoVisits >> 1

  shopDuration:  ->

  wage:          -> 2**(@skill + @style - 2)

  spawnChoicePoints: ->
    for choice in @choices
      switch choice
        when 'photo'
          time = @photoDuration()

          new ChoicePint Object.assign {}, this,
            fans:         @fans + photoFans()
            photoVisits:  @photoVisits + 1
            stress:       @stress + 24 * @photoVisits / 32
            wagesPending: @wagesPending +  * @

