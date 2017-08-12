{suite, test} = require 'joe'

suite 'hello', (suite, test) ->
  test 'world', (complete) ->
    console.log "doin' testin'"
    complete()


