{ assert, suite } = require '.'

suite 'ZIndex', (suite, test) ->
  { ZIndex } = require '..'

  suite 'constructed with two numeric dimensions', (suite, test) ->
    zIndex = null

    test 'has no entries by default', ->
      zIndex = ZIndex.create
        dimensions:
          x: type: 'numeric', from: 0, to: 255
          y: type: 'numeric', from: 0, to: 255

      assert.equal 0, zIndex.entries.length
