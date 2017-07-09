
levels = """
  haru:
    str:  [9, 13, 18, 22, 26
    cost: [5, 8, 9, 11, 13
  choyo:
    str:  [0, 24, 48, 74
    cost: [51, 55, 59, 64
  dai:
    str:  [0, 83, 168
    cost: [179, 192, 207
  ima:
    str:  [0, 304, 613
    cost: [688, 740, 795
  jin:
    str:  [0
    cost: [2908
"""

pow10 = (e) -> 10 ** e
aThousand = (n) -> n * pow10 3
aMillion = (n) -> n * pow10 6
aBillion = (n) -> n * pow10 9

delta2factor = (from, to) ->
  1 + ((to - from) / from)

levelCost = (start, level, factor = 1.075) ->
  start * factor ** level

strFactor =
  haru: haruStrFactor = delta2factor 305.48, 323.15

startingCost =
  tori  :  24.28 * 10 ** 6
  izumi : 145.89 * 10 ** 6
  karou : 962.08 * 10 ** 6

levelFactor =
  haru  : delta2factor 127.85, 137.44
  tori  : delta2factor 24.28, 26.1
  izumi : delta2factor 145.89, 156.83

###

levelJumpCost = (start, from, to, factor = 1.075) -> levelCost(start,to,factor) - levelCost(start,from,factor)
1.075 ** 222
70 / (1.075 ** 222)
70000000 / (1.075 ** 222)
startingCost
delta2factor startingCost.izumi, startingCost.karou
startingCost.hire = 6970
delta2factor  startingCost.karou, startingCost.hire

###
