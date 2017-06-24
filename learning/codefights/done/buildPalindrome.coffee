ok = ([first, middle..., last]) ->
  return false unless first is last

  if middle.length > 1
    ok middle
  else
    true

bp = buildPalindrome = (s) ->
  letters = s.split ''
  addable = letters.map (c) -> c
  append = []

  until ok letters.concat append
    append.unshift addable.shift()

  letters.concat(append).join ''

console.log bp 'abcdc'


