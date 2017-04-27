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

Object.assign module.exports, {infiniteSeries, linearSeries, powerSeries, factors},
  debug: console.log
  interests:
    allOddOrEven:
      frequency: (s) ->
        (10**s.length) / (2 ** (s.length - 1))

      test: (s) ->
        count =
          s.map (d) -> parseInt(d) % 2
           .filter (m) -> m

        count in [0, s.length]

    palindrome:
      frequency: (s) ->
        m = s.length >> 1
        10**m
        
      test: palindrome = (s) ->
        [first, middle..., last] = s
        s.length < 2 or first is last and palindrome middle

    linear:
      frequency: (s) ->
        if s.length < 3
          0
        else
          s.length * 6

      test: linear = (s, step) ->
        return false if s.match /\D/

        if not step
          for step in [-3..-1].concat [1..3]
            if linear s, step
              return true

          return false

        return (s.length < 2) or
               (parseInt((10 + s[0] + step) % 10) is parseInt(s[1])) and
               (linear s[1..], step)

    repeating:
      frequency: (s) ->
        if s.length < 4 then return 0

        factorList =
          for f from factors s.length
            break if f > s.length >> 1

        factorList
          .map (f) -> 10**f
          .reduce (a, b) -> a + b

      test: (s) ->
        if s.length < 4 then return false

        for len from factors s.length
          pattern = s[..len - 1].join('')

          for offset from linearSeries len, len
            return true if offset >= s.length
            break       if s[offset..offset + len - 1].join('') isnt pattern

        return false

  adjustments:
    partial:
      applyTo: (fn) ->
        (s) ->
          fn(s[1..  ]) or
          fn(s[ ..-2]) or
          fn(s[1..-2])

    offByOne:
      applyTo: (fn) ->
        (s) ->
          odd = (l = s.length) % 2

          mid = l >> 1

          left  = s[..mid - 1]
          right = s[mid + odd..].map (n) -> n + 1

          fn left.concat right
