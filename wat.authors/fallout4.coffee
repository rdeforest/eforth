diff = (a, b) ->
  n = 0
  for c, i in a
    n++ if b[i] is c
  n

partitions = (word, words) ->
  p = []
  for other in words when other isnt word
    d = diff word, other
    p[d] or= []
    p[d].push other
  p

filterList = (wordlist, picked...) ->
  for pick in picked
    [testedWord, matches] = pick

    wordlist = word for word in wordlist when matches is diff word, testedWord

  wordlist

# recommendation = (wordlist) ->
#   pickResults = {}
# 
#   for word in wordlist
#     pickResults[word] = partitions word, wordlist

makeTree = (wordlist) ->
  tree = {}

  for word in wordlist
    tree[word] = ([] for [0 .. word.length])

    for other in wordlist when other isnt word
      tree[word][diff word, other].push makeTree # XXX

