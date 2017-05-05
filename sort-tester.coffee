scramble = (l) ->
  ll = []

  while len = l.length
    i = Math.floor Math.random() * len
    ll.push l.splice(i, 1)[0]

  ll

tests = [
  scramble [0..2000]
  scramble [0..2000]
  scramble [0..2000]
  scramble [0..2000]
  scramble [0..2000]
]

sorted = (iterator) ->
  prev = iterator.next().value

  for next from iterator
    return false if next < prev
    prev = next

  return true

module.exports = (sorter) ->
  assert sorted sorter t for t in tests
