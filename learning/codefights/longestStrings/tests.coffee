tests = [
  [["aba", "aa", "ad", "vcd", "aba"], ["aba", "vcd", "aba"]]
]

module.exports = (allLongestStrings) ->
  for [input, want] in tests
    got = allLongestStrings input

    if JSON.stringify(got) isnt JSON.stringify(want)
      console.log "failed:", input, want, got
