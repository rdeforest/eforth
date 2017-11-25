groupSame = (acc, e) ->
  return [[e, 1]] if not acc.length

  [prev..., current] = acc

  if e is current[0]
    [prev..., [e, current[1] + 1]]
  else
    [prev..., current, [e, 1]]

convert = (n = 1, base = 10) ->
  s = n.toString base
  ret = ''

  groups =
    s .split ''
      .reduce groupSame, []

  for [value, count] in groups
    ret += count.toString base
    ret += value.toString base

  ret

sequence = (from = 1, base = 10) ->
  loop
    yield (from = convert from, base)

module.exports = {groupSame, convert, sequence}
