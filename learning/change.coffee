
# make change

standardCoins = [50, 25, 10, 5, 1]

makeChange = (goal, coins = standardCoins) ->
  if goal < 0 or not coins.length
    0
  else if goal is 0
    1
  else
    (makeChange goal, coins[1..]) +
    (makeChange goal - coins[0], coins)

Object.assign global, module.exports = {makeChange, standardCoins}
