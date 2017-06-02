module.exports = createAnagram = (given, want) ->
  needed = ''
  given = given.split('').sort()
  want = want.split('').sort()

  for char in want
    if given[0] is char
      given.shift()
    else
      needed += char

      given.shift() while given and given[0] < char

  needed.length
      
