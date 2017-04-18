util = require 'util'

module.exports =
  tester = (tests, toBeTested) ->
    for [input, want] in tests
      result = JSON.stringify toBeTested input...

      if result isnt JSON.stringify want
        console.log "FAIL input: #{util.inspect input} wanted: #{util.inspect want} got: #{util.inspect result}"
