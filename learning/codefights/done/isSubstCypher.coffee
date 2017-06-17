module.exports = isSubstitutionCipher = (from, to) ->
  forward = {}
  reverse = {}

  return false unless from.length is to.length

  for fromChar, idx in from
    was = forward[fromChar]

    if (reverse[toChar = to[idx]] or= fromChar) isnt fromChar or
       (forward[fromChar] or= to[idx]) isnt to[idx]
      return false

    console.log fromChar, was

  true
