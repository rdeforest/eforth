module.exports =
  minimalNumberOfCoins = (coins, price) ->
    coins = coins.reverse()
    needed = 0

    while price
      if price > (nextCoin = coins[0])
        needed += howMany = Math.floor price / nextCoin
        price -= howMany * nextCoin

      coins.shift()

    needed

