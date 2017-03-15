cmp = (a, b) ->
  switch
    when not (a.length + b.length) then  0
    when not a.length              then -1
    when not b.length              then  1
    when a[0] < b[0]               then -1
    when a[0] > b[0]               then  1
    else cmp a[1..], b[1..]

ucmp = (a, b) ->
  cmp a.toLowerCase(), b.toLowerCase()

isUnstablePair = (a, b) -> cmp(a, b) isnt ucmp(a, b)

module.exports = {cmp, ucmp, isUnstablePair}
