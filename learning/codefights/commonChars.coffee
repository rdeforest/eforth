commonCharacterCount = (a, b) ->
  count = 0

  for c in a.split('')
    if -1 < where = b.indexOf c
      #console.log "found #{c} in #{b} at #{where}"
      b =
        switch where
          when 0 then b[1..]
          when b.length - 1 then b[..-2]
          else b[..where - 1] + b[where + 1..]
      count++

  return count

module.exports = commonCharacterCount

tester = require './genericTester'

tests = [
  [["aabcc", "adcaa"], 3]
]

tester tests, commonCharacterCount
