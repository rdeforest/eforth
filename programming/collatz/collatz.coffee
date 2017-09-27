prev = (n) ->
  switch n % 4
    when 1 then ...
    when 3 then ...
    else ...


next = (n) ->
  m = 3 * n + 1
  m /= 2 while not (m & 1)
  i = m >> 1
  if not prev[i]
    prev[i] = n
  else
    prev[i] = Math.min n, prev[i]
  m

module.exports = {prev, next}
