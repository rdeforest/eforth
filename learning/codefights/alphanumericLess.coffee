isNumeric = (s) -> s.match /\d/

zip = (ls) ->
  lastIndex = (Math.max ls.map((l) -> l.length)...) - 1
  [0..lastIndex].map (i) -> ls.map (l) -> l[i]

tokenize  = (str) ->
  while str and str.length
    [matched, char, zeros, number, rest] = str.match /^(?:(\D)|(?:(0*)([1-9]*)))(.*)/
    str = rest
    char and= char.charCodeAt 0
    {char, zeros, number}

ufo = (a, b) ->
  (diff = a - b) and diff / Math.abs diff

numCompare = (a, b) ->
  switch
    when a is undefined then -1
    when b is undefined then 1
    else ufo a, b

compareTokenLists = (tokenLists) ->
  for tokenPair in tokenLists when cmp = compareTokens tokenPair
    return cmp

  0

compareTokens = ([ta, tb]) ->
  return 0 if ta is tb # only happens when both are undefined

  switch
    when ta is undefined     then -1
    when tb is undefined     then  1
    when ta.char and tb.char then numCompare ta.char, tb.char
    when ta.char             then  1
    when tb.char             then -1
    else numCompare ta.number, tb.number


leadingZeroCompare = (tokenLists) ->
  for [a, b] in tokenLists when a.zeros isnt b.zeros
    if cmp = numCompare a.zeros.length, b.zeros.length
      return -cmp

  0

module.exports =
  alphanumericLess = (strings...) ->
    tokenLists = zip strings.map tokenize
    
    switch
      when cmp = compareTokenLists  tokenLists then console.log "lists: #{cmp}"; cmp is -1
      when cmp = leadingZeroCompare tokenLists then console.log "zeros: #{cmp}"; cmp is -1
      else false

Object.assign global, {
  tokenize, alphanumericLess, isNumeric, numCompare,
  compareTokenLists, leadingZeroCompare
  compareTokens
  zip
}
