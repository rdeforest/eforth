isNumeric = (s) -> s.match /\d/

tokenize  = (s) ->
  s .match /(\d+)|(\D)/g
    .map (t) ->
      if isNumeric t
        [0, (t.replace /^0*/, ''), "0.#{t}"]
      else
        [1, t.charCodeAt 0]

numCompare = (a, b) ->
  (diff = a - b) and diff / Math.abs diff

compareTokens = (ta, tb) ->
  numCompare ta[0], tb[0] or
  numCompare ta[1], tb[1]

compareTokenLists = (as, bs) ->
  return 0 if not as.length
  [a, as...] = as
  [b, bs...] = bs

  compareTokens       a , b  or
  compareTokenLists   as, bs

leadingZeroCompare = (as, bs) ->
  as.length and (not a[0] and numCompare a[2], b[2]) or leadingZeroCompare as, bs

module.exports =
  alphanumericLess = (strings...) ->
    [a, b] = strings.map tokenize
    compareLast = Math.min a.length, b.length
    as = a[..compareLast]
    bs = b[..compareLast]

    compareTokenLists  as      , bs       or
    numCompare         a.length, b.length or
    leadingZeroCompare a       , b

Object.assign global, {
  tokenize, alphanumericLess, isNumeric, numCompare, compareTokens,
  compareTokenLists, leadingZeroCompare
}
