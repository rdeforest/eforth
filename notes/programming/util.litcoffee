parents = (o) ->
  pl = [o]
  while p = o.__proto__
    pl.push p
    o = p
  pl

ownProps = (o) -> Object.getOwnPropertyNames o

definedOn = (o, name) ->
  for p in parents o
    return p if ownProps(o).filter (x) -> x is name

  return undefined

defines = (o) -> Object.getOwnPropertyNames o
