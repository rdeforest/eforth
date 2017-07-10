###

Some calculous...

d = Damage, L = level

dD''/dL = 0.02, maybe?

Some data

Haru
lv 1 str 5 cost 5
   2     7      8
   3    10      9
   4    12     11
   5    14     13
   6    18     15
        20     17
        24     20

  21   108    108

  40   510    416

Jin
   0     0   2908
   1   804   3126
   2  1615   3361

###

discrete =
  diff: (values) ->
    values[1..].map (n, i) -> n - values[i]

range = (from, to, step = 1) ->
  switch
    when 'number' isnt typeof step        then throw new Error "Non-numeric step."
    when step is 0                        then throw new Error "Zero step not allowed."
    when (iter = (to - from) / step) < 0  then throw new Error "Invalid step: #{to} - #{from} / #{step} is negative (#{iter})"

  cur = from
  
  while cur <= to
    yield cur
    cur += step

COST_GROWTH = 1.075

costFn = (lvl, base) ->
  base * (COST_GROWTH) ** (lvl - 1)

dmgFn = (lvl, base) ->

Object.assign global, module.exports = {
  discrete, range
}


