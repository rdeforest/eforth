merge = (a, b, predicate = (a, b) -> a < b) ->
  a = a[Symbol.iterator]()
  b = b[Symbol.iterator]()

  [aNext, bNext] = [a.next(), b.next()]

  if aNext.done
    if bNext.done
      return

    yield bNext.value
    yield from b
    return

  if bNext.done
    yield aNext.value
    yield from a
    return
    
  [aValue, bValue] = [aNext.value, bNext.value]

  loop
    if predicate aValue, bValue
      yield aValue

      if ({value: aValue} = (aNext = a.next())).done
        yield bValue
        yield from b
        return
    else
      yield bValue

      if ({value: bValue} = (bNext = b.next())).done
        yield aValue
        yield from a
        return

partition = (list) ->
  mid = list.length >> 1

  [ list[..mid - 1]
    list[mid..]
  ]

module.exports.sort = sort = (list) ->
  if list.length < 2 then return list

  [a, b] = partition list
  merge sort(a), sort(b)
