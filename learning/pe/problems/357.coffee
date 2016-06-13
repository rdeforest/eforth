###

https://projecteuler.net/problem=357

Consider the divisors of 30: 1,2,3,5,6,10,15,30.
It can be seen that for every divisor d of 30, d+(30/d) is prime.

Find the sum of all positive integers n not exceeding 100 000 000
such that for every divisor d of n, d+n/d is prime.

(1) Numbers that are one less than a composite are out because one is always a
divisor, n/1 == n, n is odd per above and n+1 is even which can't be prime.

(2) Odd numbers are out due to (1) because they are all one less than a composite

(3) Numbers with duplicate factors are out because:

    n = x * x * y # premise

    # Considering factor 'x'
    x + n/x == x + x * y == x * (y + 1)

    # which is a composite of x

(4) Numbers which are 2 times a factor which is 2 less than a composite are out because

    # Given 2 above
    n = 2 * ((p * q) - 2)

    # Considering factor '2'
         2 + n/2
      == 2 + (p*q) - 2
      == p * q

    # which is composite

    This is really just a specialized case of the original problem using 2.

(4.1) Generalized...


###

{progress} = require '../util'
{divisors, factor, isPrime, primes} = require '../prime'

prime.load()

sum = (l) ->
  if l.reduce
    l.reduce (a, b) -> a + b
  else if l.next
    t = 0
    t += n.value while not (n = l.next()).done
    t

testNumber = (n, show) ->
  if true is show
    show = (info...) -> console.log info

  if rule1 = not (isPrime n + 1)
    return "rule1"

  factors = factor n

  if rule4 = factors.length is 2 and not isPrime factors[1] + 2
    return "rule4"

  if rule3 = (factors
      .map (n, i) -> factors[i+1] is n
      .filter (t) -> t
      .length)
    return "rule3"

  dlist = divisors n
    .sort (a, b) -> a - b

  if show
    ok = true

    for d in dlist
      ok = ok and pTest = isPrime (v = d + n/d)
      show n, d, v, pTest

  else
    ok = -1 is culprit = dlist.findIndex (d) -> not isPrime d + n/d

  if not ok
    console.log "\rDOH #{n}: #{dlist[culprit]} - #{factors}"

  return ok

naive = (top = 100000000) ->
  naive.found = found = [1]
  statusUpdate = progress interval: 0.5, -> "#{n}/#{top}, #{found.length}"

  for n in [2 .. top] by 2
    statusUpdate()

    if true is testNumber n
      found.push n

  statusUpdate 'forced'

  return sum found

clever = (top = 100000000) ->
  pTop = Math.floor Math.sqrt(top)

  statusUpdate = progress interval: 2, ->
    prime.save()
    "#{p}, #{pTop}, #{q}, #{m}"

  # 1 is a given I think?
  clever.found = found = new Set [1]
  total = 1 # sum of found
  count = 1 # number found

  pGen = prime.primeGen()
  loop
    p = pGen.next().value

    if p*p > top
      statusUpdate true
      return sum found

    qGen = prime.primeGen p
    loop
      q = qGen.next().value

      m = p * (q - p)

      if m > top
        break

      statusUpdate()

      # TODO: demystify this :P
      if true is result = testNumber m
        count++
        total += m
        found.add m

module.exports = clever

module.exports.test = testNumber
module.exports.naive = naive
module.exports.show = (n) -> solution.test n, (info...) -> console.log info
