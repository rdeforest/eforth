###

We define the weakness of number x as the number of positive integers smaller
than x that have more divisors than x.

It follows that the weaker the number, the greater overall weakness it has.
For the given integer n, you need to answer two questions:

  what is the weakness of the weakest numbers in the range [1, n]?
  how many numbers in the range [1, n] have this weakness?

Return the answer as an array of two elements, where the first element is the
answer to the first question, and the second element is the answer to the
second question.

###

memo = (fn, keyFn = (n) -> n) ->
  stored = {}
  (args...) ->
    stored[keyFn args...] ?= fn args...

divides =
  memo ((n, m) -> 0 is n % m),
       ((n, m) -> "#{n}:#{m}")

divisors = memo (n) -> [1..n].filter (m) -> n % m is 0

numDivisors = (n) -> divisors(n).length

strongerThan = memo (n) ->
  return 0 if n < 2

  ownDivisors = numDivisors n

  [1..n - 1]
    .filter (m) -> numDivisors(m) > ownDivisors

weakness = (n) ->
  return 0 if n < 2
  strongerThan(n).length

weakest = memo (n) ->
  winner = [0, 0] # weakness, count

  for m in [1 .. n]
    if (w = weakness m) > winner[0]
      winner = [w, 1]
    else if w is winner[0]
      winner[1]++

  return winner

module.exports = {strongerThan, divisors, weakness, weakest, numDivisors, divides}
