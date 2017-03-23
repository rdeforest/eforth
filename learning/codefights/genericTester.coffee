module.exports =
  tester = (tests, toBeTested) ->
    for [input, want] in tests
      result = JSON.stringify toBeTested input...

      if result isnt want = JSON.stringify want
        console.log "FAIL input: #{JSON.stringify input} wanted: #{want} got: #{result}"
