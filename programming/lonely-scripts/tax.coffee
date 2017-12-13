
# Please don't tax coffee! :)

# From https://taxfoundation.org/2017-tax-brackets/

rates = [
    [     9325,         0, 0.00  ]
    [    37950,         0, 0.10  ]
    [    91900,   5226.25, 0.15  ]
    [   191650,  18713.75, 0.25  ]
    [   416700,  46643.75, 0.28  ]
    [   418400, 120910.25, 0.33  ]
    [ Infinity, 121505.25, 0.396 ]
  ]

findBracket = (income) ->
  (rates.find ([cap]) -> income < cap) or throw new Error "#{income} > Infinity?!"

tax = (income) ->
  [cap, deduct, rate] = findBracket income

  (income - deduct) * rate

floor = (n, factor = 4) -> Math.floor(n * factor) / factor

offset = (diff, rate) -> floor Math.abs (diff + diff * rate)

toTakeHome = (goal, margin = 1000) ->
  income = goal
 
  for round in [1..10]
    switch
      when (diff = floor(takeHome(income) - goal)) > margin
        console.log "to solve for #{diff}, reducing from #{income} to #{
        income = floor (income - offset diff, rate)
        }"

      when diff < 0
        [cap, deduct, rate] = findBracket income

        console.log "to solve for #{diff}, raising from #{income} to #{
        income = floor (income + offset diff, rate)
        }"

      else break

  return income

takeHome = (income) ->
  floor (income - tax income)

Object.assign module.exports, {rates, tax, toTakeHome, takeHome}
