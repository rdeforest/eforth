(require 'global') global

parent = (o) -> Object.getPrototypeOf o

ancestors = (o) ->
  if p = parent o
    [p].concat ancestors p
  else
    []

commonAncestor = (a, b) ->
  for aAncestor in ancestors a
    if b instanceof aAncestor
      return aAncestor

  undefined

cmp = Symbol 'compare'

boxOf = (o) ->
  t = typeof o
  T = t[0].toUpperCase() + t[1..]

  switch typeof o
    when 'object'
      if Array.isArray o
        Array
      else
        Object
    when obviousBox = global[T] then obviousBox

module.exports = (Object) ->
  Object.cmp = (a, b) ->
    switch
      when a is b  then 0
      when a?[cmp] then a[cmp] b
      when b?[cmp] then -(b[cmp] a)
      when a in [null, undefined]
        if b in [null, undefined] then 0 else -1
      when b in [null, undefined] then 1
      when 'string' is typeof a
        
      when 'number' is typeof a
        if 'number' is typeof b
          a - b
        else
          -1
      when 'object' is typeof a
        return 1 if 'object' isnt typeof b
