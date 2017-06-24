hasDupe = ([x, xs]) -> xs.length > 0 and (x in xs or hasDupe xs)

# Also handle '43934727' or 'abcbaded'

# a..g represent repeated characters, x represents a wildcard
patternSchemes = [
  'aaaaaaaa', 'aaaabbbb', 'aaxxaaxx', 'abababab'
  'aabbbbaa', 'ababbaba', 'abbaabba', 'aaababbb'
  'abccccba', 'abcdacbd', 'abcddcba', 'abacadae'
  'abacadac', 'abacabad'
]

class DigitScheme
  constructor: (from) ->
    @base = 10
    @_regexp = null
    @_matcher = null

    if (t = typeof from) and init = @["_#{t}Init"]
      return init.call @, from

  odds: ->
    combinations = 1

    for {ref, any, part} in @parts
      combinations *=
        switch
          when ref  then 1
          when any  then @base
          when part then @base
          else 1

    [combinations, (@base ** @parts.length)]

  regexp:      ->  @_regexp or= new RegExp @partsToPattern()

  matches: (s) -> (@_matcher or= @makeMatcher()) s

  partsToPattern: ->
    p = (for {ref, any, part} in @parts
      switch
        when ref  then "\\#{ref}"
        when any  then "."
        when part then "\(.\)"
        else throw new Error "unknown part type in #{JSON.stringify @parts}"
    ).join ''

  makeMatcher: ->
    (s) => matched = s.match @regexp() and not hasDupe matched[1..]

  _stringInit: (s) ->
    @parts = []
    refs = []
    seen = {}
    
    for part in s.split ''
      switch
        when ref = seen[part]  then @parts.push {ref}
        when any = part is 'x' then @parts.push {any}
        else
          seen[part] = refs.push part
          @parts.push {part}

    @

  _objectInit: (o) ->
    if o instanceof DigitScheme
      created =
        if @constructor isnt o.constructor
          Object.create o.constructor::
        else
          @
      Object.assign created, o
    else
      if Array.isArray o
        @parts = o
      else
        @parts = Array.from o.parts or []
      @

# A digit scheme which would match even if one digit differed from the
# expected digit by one. Adds permutation of number of back-references times
# number of ways to differ.
#
# base | ways to differ
#  2   | (2 / 2)
#  3   | (4 / 3)
#  4   | (6 / 4)
#  n   | (n * 2 - 2 / n)
class OffByOne extends DigitScheme
  odds: ->
    combinations = 1
    refCount = 0

    for {ref, any, part} in @parts
      combinations *=
        switch
          when ref  then refCount++; (2 + (@base - 2) * 3) / @base
          when any  then @base
          when part then @base
          else 1

    [combinations, (@base ** @parts.length)]

  makeMatcher: ->
    (s) =>
      s = s.toString()
      matched = [s]
      matched.index = 0
      matched.input = s

      for {ref, any, part}, i in @parts
        if (v = matched[ref]) isnt undefined and not (v - 1 <= parseInt(s[i]) <= v + 1)
          return null

        else if part
          if (n = parseInt s[i]) in matched
            return null

          matched.push n

      return matched

class SameOddness extends DigitScheme
  constructor: (@length = 8, @base = 10) ->

  odds: -> [2 * (@base / 2) ** @length, @base ** @length]

  makeMatcher: ->
    sameOddness = (s) ->
      -1 < [0, s.length].indexOf (
        numberOfOdds =
          s.split ''
            .map (c) -> parseInt(c) % 2
            .reduce (a, b) -> a + b)

    (s) ->
      if sameOddness s
        Object.assign [s, 1 is parseInt(s[0]) % 2],
          input: s
          offset: 0


class Palindrome extends DigitScheme
  constructor: (@length = 8, @base = 10) ->

  odds: -> [@base ** (@length >> 1), @base ** @length]

  makeMatcher: ->
    palindromic = (s) ->
      half = s.length >> 1
      return [s, ''] if half < 1

      [left, middle..., right] = s
      return s[0..half] if left is right and palindromic middle

class Linear extends DigitScheme
  constructor: (@length = 8, @base = 10) ->

  odds: ->
    wiggle = Math.max 0, ((@base - @length) + 1)
    ways = wiggle * Math.floor @base / @length
    [ways, @base ** @length]

  makeMatcher: ->
    linear = (s, delta) ->
      return true if s.length < 2

      if 'number' isnt typeof delta
        digits = s.split('').map (d) -> parseInt d

        if delta = digits[1] - digits[0]
          linear digits[1..], delta
        else
          null
      else
        digits[0] + delta is digits[1] and linear digits[1..], delta

    (s) ->
      if linear s
        Object.assign [s, parseInt(s[1]) - parseInt(s[0])],
          input: s
          offset: 0

Object.assign module.exports, {
    DigitScheme, OffByOne, SameOddness, Palindrome, patternSchemes
    #, infiniteSeries, linearSeries, powerSeries, factors
  },
  debug: console.log

###
infiniteSeries = (fn, start = 0) ->
  n = start

  loop
    yield n
    n = fn n

linearSeries = (start = 0, step = 1) ->
  n = start - step

  loop
    yield n += step

powerSeries = (base, powerIt) ->
  n = base

  for power from powerIt
    yield n**power

# Not including 1 and n because they are not the useful factors
factors = (n) ->
  for i from linearSeries 2
    if i >= n
      break

    if n % i
      continue

    yield i
  null

debug = (args...) -> module.exports.debug args...

String::is (valueOrTest) ->
  if 'function' is typeof valueOrTest
    valueOrTest    @
  else
    valueOrTest is @

###
