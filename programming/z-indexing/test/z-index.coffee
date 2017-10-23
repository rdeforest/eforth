{ assert, suite } = require '.'

rand = (n) -> Math.floor Math.random() * n

suite 'ZIndex', (suite, test) ->
  { ZIndex } = require '..'

  suite 'constructed with two numeric dimensions', (suite, test) ->
    zIndex = null

    test 'has no entries by default', ->
      zIndex = ZIndex.create
        dimensions:
          x: to: 255
          y: to: 255

      assert.equal 0, zIndex.size

    testCoords = [].concat (
      for x in [0, 1, 10, 100, rand 256]
        for y in [0, 2, 20, 200, rand 256]
          {x, y}
      )...

    test 'maps multiple dimension indexes to a single z index and back', ->
      for {x, y} in testCoords
        zidx = zIndex.getZIndex testCoord
        coords = zIndex.getCoords zIdx

        assert.equal coords.x, x
        assert.equal coords.y, y

    created = []

    test '::set associates objects with coordinates and ::get retrieves them', ->
      for {x, y} in testCoords
        created.push {x, y, o: o = Symbol "[#{x}, #{y}]"}
        zIndex.set {x, y}, o

      for {x, y, o} in created
        assert.equal o, zIndex.get {x, y}

    suite '::[Symbol.iterator]', (suite, test) ->
      enumerated = null

      test '::[Symbol.iterator] enumerates all contents' ->
        enumerated = (entry for entry from zIndex)
        assert.equal created.length, enumerated.length

      test '::[Symbol.iterator] enumerates contents in Z order', ->
        distances =
          enumerated
            .map  ({x, y}) -> zIndex.getZIndex {x, y}
            .map (a, i, l) -> if i then a - l[i - 1]
            .filter (a, i) -> i

        assert.equal 0, (distances.filter (d) -> d <= 0).length

    suite '::delete', (suite, test) ->
      deleted = []

      test 'shortens the instance', ->
        for {x, y} in created when rand 2
          deleted.push zIndex.delete {x, y}

        expectedSize = created.length - deleted.length
        assert.equal zIndex.size, expectedSize

    suite '::has', (suite, test) ->
      test 'only returns true for non-deleted coordinates', ->
        for {x, y, o} in created
          assert.equal (o in deleted), not zIndex.has {x, y}

    suite '::get', (suite, test) ->
      test 'returns the correct objects after deletions', ->
        for {x, y, o} in created when o not in deleted
          assert.equal o, zIndex.get {x, y}

    suite '::search', (suite, test) ->
      test 'enumerates a limited subset', ->
        zIndex.set {x:  0, y:   1}, Symbol()
        zIndex.set {x:  1, y:   0}, Symbol()
        zIndex.set {x:101, y:   3}, Symbol()
        zIndex.set {x: 99, y: 103}, Symbol()

        range =
          x: from: 1, to: 100
          y: from: 1, to: 100

        for entry from zIndex.search range
          assert 1 <= entry.x <= 100, 'x in range'
          assert 1 <= entry.y <= 100, 'y in range'
          entry
