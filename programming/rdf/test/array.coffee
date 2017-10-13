path    = require 'path'
assert  = require 'assert'
{suite} =
joe     = require 'joe'

class TestArray extends Array

suite 'Array extensions', (suite, test) ->
  (require '../../lib/array') TestArray

  test 'extends passed object', ->
    assert undefined is       Array::hasDupe
    assert undefined isnt TestArray::hasDupe

  suite 'adds sorted list features', ->
    numeric = (a, b) -> a - b
    (l = [1..5]).sortWith = numeric
    l = l.sort()




