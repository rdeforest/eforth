module.exports =
  (almostIncreasingSequence) ->
    tests =
      true: [
        [1, 2, 3]
        [-3, -2, -1]
        [10, 1, 2, 3, 4, 5]
        [1, 2, 3, 4, 3, 6]
        [1, 2, 3, 4, 99, 5, 6]
      ]
      false: [
        [1, 3, 2, 1]

        [1, 2, 1, 2]
        [4, 5, 3, 4]
        [1, 1, 1, 2, 3]
        [1, 2, 3, 4, 99, 4, 6]
        [4, 5, 3, 5, 6]
      ]
      other: [
      ]

    for t in tests.true
      if not   almostIncreasingSequence t
        console.log "Expected true, got false:", t

    for t in tests.false
      if why = almostIncreasingSequence t
        console.log "Expected false, got #{why}:", t

    for t in tests.other
      got = almostIncreasingSequence t
      console.log "Got #{got} for ", t
