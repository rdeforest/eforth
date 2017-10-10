{suite, test} = require '.'

suite 'Progress reporter', (suite, test) ->

  test 'logs at least once per interval', (complete) ->
    
