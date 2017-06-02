digitSum = (n) ->
  if n < 10
    n
  else
    m = n % 10
    m + digitSum (n - m) / 10

module.exports = mostFrequentDigitSum = (n) ->
  most = [0, 0]
  freq = new Array 50
    .fill 0

  while n > 0
    ds = digitSum n

    if ++freq[ds] > most[0]
      most = [freq[ds], ds]

    if freq[ds] is most[0]
      most.push ds

    n = n - ds

  most[1..].sort((a, b) -> b - a)[0]
