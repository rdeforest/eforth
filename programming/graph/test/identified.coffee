{suite, test} = require '../util/setup-testing'

{ Identified } = require '../src/identified'

suite 'Identified', (suite, test) ->
  test 'constructor supplies incrementing id', ->
    first = new Identified
    assert second.id - first.id > 0, 'second id not greater than first'
