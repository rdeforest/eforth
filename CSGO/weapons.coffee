SEMI    = Symbol "Semi-automatic"
BURST   = Symbol "Burst"
AUTO    = Symbol "Full-automatic"

PISTOL  = Symbol 'Pistol'
SHOTGUN = Symbol 'Shotgun'
SMG     = Symbol 'Sub-machine gun'
RIFLE   = Symbol 'Rifle'
OTHER   = Symbol 'Other'

TERR    = Symbol "Terrorists"
CTERR   = Symbol "Counter-Terrorists"
BOTH    =
ANYONE  = Symbol "Both teams"

symString = (s) -> s.toString()[7..-2] or 'unnamed symbol'


fields = do ->
  isBoolean  =           (v)    -> v if 'boolean' is typeof v

  numeric    =           (n)    -> n if 0 <= n = Math.abs(parseFloat n)
  positive   =           (n)    -> n if 0 < (n = numeric n)
  between    = (a, b) -> (n)    -> n if a <= n <= b
  moreThan   = (a)    -> (n)    -> n if n = numeric(n) and 0 < n

  valueIn    = (l...) -> (v)    -> v if v in l
  atLeastOne = (p)    -> (l)    -> (l?.filter? p)?.length or undefined
  someOf     =           (l...) -> atLeastOne valueIn l

  return fields =
    type             : valueIn    PISTOL, SHOTGUN, SMG, RIFLE, OTHER
    killAward        : between    50, 16000
    magazineCapacity : moreThan   0
    totalRounds      : moreThan   0
    fireRate         : moreThan   0
    reloadTime       : moreThan   0
    tOnly            : isBoolean
    ctOnly           : isBoolean
    defaultEquipped  : valueIn    TERR, CTERR
    damage           : moreThan   0
    range            : moreThan   0
    penetration      : moreThan   0
    movement         : moreThan   0
    modes            : someOf     SEMI, BURST, AUTO
    canBuy           : atLeastOne TERR, CTERR

module.exports =
  class Weapon
    @s: {}

    constructor: (@name, info) ->
      for k, v of info when k not in Object.getOwnPropertyNames fields
        console.log "Unexpected value #{@name}.#{k} =", v

      for k, v of info
        for fName, validator of fields
          if not info[k]
            console.log "Missing value #{@name}.#{k}"
          else if not fields[k] or undefined is @[k] = fields[k] info[k]
            console.log "Could not validate #{@name}.#{k} =", v

      Weapon.s[@name] = @

    @like: (other, name, diff) ->
      new Weapon name, Object.assign {}, other, diff

    toString: ->
      [@name + ':', Object.getOwnPropertyNames(fields).map((f) => "#{f}: #{@[f]}")...].join "\n  "

    @toString: ->
      for name, weapon of Weapon.s
        console.log weapon.toString()

usp_s = new Weapon "USP-S",
    cost             : 1700
    killAward        : 300
    magazineCapacity : 25
    totalRounds      : 100
    modes            : AUTO
    fireRate         : 571
    movement         : 240
    reloadTime       : 3500
    canBuy           : BOTH
    ctOnly           : false
    defaultEquipped  : CTERR
    damage           : 35
    range            : 20    # m
    penetration      : 100

Weapon.like usp_s, "glock-18",
    cost             : 400,
    magazineCapacity : 20
    totalRounds      : 120
    modes            : [SEMI, BURST]
    fireRate         : [400, 1200]

ump_45 = new Weapon "UMP-45",
    cost             : 1700
    killAward        : 300
    magazineCapacity : 25
    totalRounds      : 100
    modes            : AUTO
    fireRate         : 571
    movement         : 230
    reloadTime       : 3500
    tOnly            : false
    ctOnly           : false
    defaultEquipped  : true
    damage           : 35
    range            : 20    # m
    penetration      : 100

console.log Weapon.toString()
