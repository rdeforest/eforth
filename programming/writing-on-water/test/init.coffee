{ assert, suite, test, lib } = require '.'

suite 'wow', (suite, test) ->
  wow = lib 'wow'

  suite '.new', (suite, test) ->
    test '', ->
