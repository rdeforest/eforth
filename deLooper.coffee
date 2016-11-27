clean = (o, seen = new Set) ->
  if o is null or typeof o not in ['function', 'object']
    return o

  seen.add o

  if Array.isArray o
    for el in o when not seen.has el
      clean el, seen
  else
    if (keys = Object.getOwnPropertyNames o).length
      Object.assign {},
        ( for k in keys when not seen.has (v = o[k])
            "#{k}": clean v, seen
        )...

