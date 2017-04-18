module.exports =
  depositProfit = (deposit, rate, threshold) ->
    return Math.ceil(Math.log(threshold / deposit) / Math.log (rate / 100))

