module.exports =
  switchLights = (candles) ->
    reversing = false

    (for candle in candles.reverse()
      if candle
        reversing = not reversing

      if reversing
        1 - candle
      else
        candle
    ).reverse()
