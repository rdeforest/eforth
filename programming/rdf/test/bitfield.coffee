{ suite
  assert
} = require '../lib/setup-testing'

randInt = (range) -> Math.floor Math.random() * range

numeric = (a, b) -> a - b

uniq = (reduced, element) ->
  reduced.push element unless element in reduced
  reduced

flatten = (flattened, el) -> flattened.concat el

grabSome = (bag, howMany) ->
  bag = Array.from bag

  [1 .. howMany].map -> (bag.splice randInt bag.length, 1)[0]

suite 'BitField', (suite, test) ->
  { BitField } = require '../lib/bitfield'

  test '::addressOf', ->
    bitField = new BitField
    {cell, bit, mask} = bitField.addressOf 0

    assert.equal cell, 0, "correct cell"
    assert.equal bit , 0, "correct bit"
    assert.equal mask, 1, "correct mask"

  test '::[Symbol.iterator] exists', ->
    bitField = new BitField

    assert.equal 'function', typeof bitField[Symbol.iterator]

  test '::test result defaults to false', ->
    bitField = new BitField
    assert not bitField.test 0

  test '::set makes ::test result change', ->
    bitField = new BitField

    i = 3
    assert not bitField.test i
    bitField.set i
    assert     bitField.test i


  test '::[Symbol.iterator] yields true indexes', ->
    testIndexes =
      grabSome([1 .. 1023], 10)
        .concat 0, 2 ** 32 - 1
        .sort numeric

    bitField = new BitField

    testIndexes.forEach (i) -> bitField.set i

    yielded = (i for i from bitField).sort numeric

    difference = yielded.filter (el, i) -> el isnt testIndexes[i]

    assert.equal yielded.length, testIndexes.length, "result same length as test list"
    assert.equal 0, difference.length, "No differences"

