class Counter
  constructor: ->
    @steps = [0, 0]
    @most = 0
    @bigOnes = []

  count: (n) ->
    if 'number' is typeof @steps[n]
      return @steps[n]

    latest = @steps[n] = 1 + @count(
      if n % 2
        n * 3 + 1
      else
        n >> 1
    )

    if latest > @most
      @bigOnes = [latest]
      @most = latest
    else if latest is @most
      @bigOnes.push n

    return latest

module.exports = new Counter
