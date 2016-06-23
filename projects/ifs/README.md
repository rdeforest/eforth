# Iterated Function System toy

A system is a colleciton of transforms. A transform is a function and some
parameters. The system applies each transform to the current data set then
merges the results. The parameters modify the behavior of the function they're
associated with. For example, one parameter might be 'scale' and it might be a
constant the vector members get multiplied by.

# Models

## IFunction

  - has
    - parameterNames
    - code
  - does
    - transform vector => newVector 
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
    - transformPoint [x, y]

## ImageTransform extends Transform

  - has
    - ctx
  - does
    - transformImage

## IFSystem

  - does
    - iterate
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
