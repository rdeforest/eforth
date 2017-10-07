joe = require './setup-testing'

{suite} = joe

suite "floodfill", (test) ->
  test "does nothing when start point is already destination color", ->
