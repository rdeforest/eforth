# Let's try this again...

isNaN = Number.isNaN

Object.assign module.exports, {
  gopn       : gopn        = Object.getOwnPropertyNames
  gops       : gops        = Object.getOwnPropertySymbols

  hasOwnProp : hasOwnProp  = (propname) -> (o) -> propname in gopn o
  getOwnProp : getOwnProp  = (propname) -> (o) ->
    if hasOwnProp(propname)(o)
      o[propname]
    else
      undefined

  hasProp    : hasProp     = (propname) -> (o) -> propname in Object.keys o
  getProp    : getProp     = (propname) -> (o) -> o[propname]
  setProp    : setProp     = (propname) -> (value) -> (o) -> o[propname] = value

  deepCompare: deepCompare = (a, b) ->
    switch
      when isNaN  a and isNaN   b then true
      when        a is          b then true
      when    not a               then false
      when 'object' isnt typeof a then false
      when 'object' isnt typeof b then false
      else a.deepCompare b


Object::deepCompare = (v) ->
  switch
    when @constructor isnt v.constructor then false
    when not gopn(@).deepCompare gopn(v) then false
    when not gops(@).deepCompare gops(v) then false
    else
      for k, e of @ when v[k] isnt e and not deepCompare e, v[k]
        return false

      true

Array::deepCompare = (v) ->
  switch
    when not Array.isArray v   then false
    when @length isnt v.length then false
    else
      for e, i in @ when v[i] isnt e or not deepCompare v[i], e
        return false

      true

#Array::deepHas = (v) ->
#  v in @ or -1 < @findIndex (e) -> deepCompare v, e

Map::deepCompare = WeakMap::deepCompare = (v) ->
  return false unless v instanceof @constructor
  return false unless @size is v.size
  return false for k, e from a when not b.deepHas k, e
  true

Map::deepHas = WeakMap::deepHas = (k, v) ->
  @has(k) and ((v is (v2 = @get(k))) or deepCompare v, v2)

Set::deepCompare = WeakSet::deepCompare = (v) ->
  return false unless @size is v.size

  bObjs = new Set(e for e from v when 'object' is typeof e)

  `value: {` for v from @ when not b.has v
    return false unless 'object' is typeof v

    missing = do ->
      for e from bObjs when deepCompare v, e
        bObjs.delete e
        return false

      true

    return false if missing
  `}`

  return true

Set::deepHas = WeakSet::deepHas = (v) ->
  return true if @has(v)

  for e from @ when v is e or deepCompare v, e
    return true

  false

deepCopy = (v) ->
  if 'object' is typeof v
    v.deepCopy()
  else
    v

Object::deepCopy = ->

  for k, v of @
    copy[k] = deepCopy v

  copy

  props = Object.getOwnPropertyDescriptors @

  for k, {value, writable, enumerable, configurable} of props
    if typeof value isnt 'function'
      props[k].value = deepCopy value

  s = Object.create @constructor::, props

Buffer::deepCopy = -> Buffer.of @

Set::deepCopy = WeakSet::deepCopy = ->
  s = super()

  for v from @values()
    s.add deepCopy v

  s

Map::deepCopy = WeakMap::deepCopy = ->
  s = super()

  for [k, v] from @entries()
    s.set deepCopy(k), deepCopy v

  s
