module.exports =
  timedReading = (maxLength, text) ->
    text
      .split /\W+/
      .filter (w) -> 0 < w.length <= maxLength
      .length

