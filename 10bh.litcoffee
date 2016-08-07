        #  cost              lps           thirdUpgrade
    tiers = [
        [  15,               1,            120  ]
        [  240,              5,            120  ]
        [  4000,             50,           120  ]
        [  7200,             80,           120  ]
        [  10000,            100,          120  ]
        [  50000,            150,          120  ]
        [  150000,           200,          120  ]
        [  500000,           500,          120  ]
        [  2400000,          2000,         110  ]
        [  12800000,         9000,         100  ]
        [  100000000,        60000,        90   ]
        [  1320000000,       660000,       80   ]
        [  25000000000,      6750000,      70   ]
        [  360000000000,     108000000,    65   ]
        [  6400000000000,    1280000000,   60   ]
        [  100000000000000,  10000000000,  50   ]
      ]

    sum = (l) -> l.reduce ((a,b) -> a+b), 0

    Sigma = (from, to, fn) -> sum [from .. to].map(fn)

    class Tier
      constructor: (@baseCost, @baseLPS, @thirdUpgrade = 100) ->

      levelCost: (from, to = from + 1) ->
        Sigma from, to - 1, (n) -> @baseCost * 1.15 ** n

      levelLPS: (lvl, upgrades = 0) ->
        lps = @baseLPS * lvl
        lps *= 2  if upgrades > 0
        lps *= 10 if upgrades > 1
        lps *= 10 if upgrades > 2

      upgradeCost: (from, to = from + 1) ->

      options: (lvl, upgrades = 0) ->
        result =
          accumulate: 0
          spend: 0
          elapsed: 0

        options =
          wait: (s) ->
            accumulate: s * @levelLPS lvl, upgrades
            elapsed: s
            spend: 0
          upgrade: (s) ->
            accumulate: s * @levelLPS lvl, upgrades + 1
            elapsed: s
            spend: @upgradeCost upgrades
          level: (s) ->
            Object.assign {}, result,
              accumulate: s * @levelLPS lvl, upgrades + 1
              elapsed: s

    wives = tiers.map (t) -> new Tier t...

    module.exports = {tiers, Tier, wives, Sigma}
