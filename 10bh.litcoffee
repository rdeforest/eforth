        #            cost          lps  thirdUpgrade    costFactors       sciNot     alsoIs                       AND also
    tiers = [                                  #         2   3   5   11
        [              15,           1, 120  ] #             1   1       1.5  e  1   15 * 1                                      (4^2 - 1) * 10^0
        [             240,           5, 120  ] #         4   1   1       2.4  e  2   16 * c(1)                   24 * 10^1       (5^2 - 1) * 10^1
        [            4000,          50, 120  ] #         5       3       4.0  e  3  125 * 2^5                   400 * 10^1       (5   * 8) * 10^2
        [            7200,          80, 120  ] #         5   2   2       7.2  e  3   30 * c(2)                  8*9 * 10^2       c(1) * c(2) * 2
        [           10000,         100, 120  ] #         4       4       1.0  e  4  100 * 100                  10^2 * 10^2       (100^2)
        [           50000,         150, 120  ] #         4       5       5.0  e  4    5 * c(5)                  500 * 10^3       (6   - 1) * 10^4
        [          150000,         200, 120  ] #         4   1   5       1.5  e  5      * c(1) * c(5)           150 * 10^3
        [          500000,         500, 120  ] #         5       6       5.0  e  5   10 * c(5)                  500 * 10^4
        [         2400000,        2000, 110  ] #         5   1   5       2.4  e  6        c(2) * c(5)          c(2) * 10^4
        [        12800000,        9000, 100  ] #         12      5       1.28 e  7   10 * c(5) * 2^7          2*8^2 * 10^5
        [       100000000,       60000,  90  ] #         7       7       1.0  e  8        c(5) * c(5)          10^2 * 10^5 * 10
        [      1320000000,      660000,  80  ] #         9   1   7   1   1.32 e  9  100 * c(2) * c(6)         11*12 * 10^6 * 10
        [     25000000000,     6750000,  70  ] #         9       11      2.5  e 10                              5^2 * 10^6 * 1000
        [    360000000000,   108000000,  65  ] #         12  2   10      3.6  e 11                              6^2 * 10^7 * 1000
        [   6400000000000,  1280000000,  60  ] #         17      11      6.4  e 12                              8^2 * 10^8 * 10000
        [ 100000000000000, 10000000000,  50  ] #         14      14      1.0  e 14                             10^2 * 10^9 * 10000
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
