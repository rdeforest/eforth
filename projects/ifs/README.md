# Iterated Function System toy

A system is a colleciton of transforms. A transform is a function and some
parameters. The transform applies

# Models

## IFunction

  - does
    - transformPoint {x, y, ...} -> {x1, y1, ...}
  - has
    - parameterNames
    - code
  - hasMany
    - Transorms

## Transform

  - has
    - parameterValues
  - belongsTo
    - IFunction
    - IFSystem

## PointTransform extends Transform

  - does
    - transformPoint {x, y}

## ImageTransform extends Transform

  - does
    - transformImage (ctx)

## IFSystem

  - does
    - renderFrame
  - has
    - name
  - hasMany
    - Transforms

# Instances

## linearTransform

```coffee

class LinearIFunction extends IFunction
  constructor: ->
    super paramNames:
      scale: {1,1}
      skew: {0,0}
      shift: {0,0}

```

  transformPoint

  - is IteratedFunction
  - sets
    - parameterNames = [...]
    - code
