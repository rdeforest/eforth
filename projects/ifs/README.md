# Iterated Function System toy

# Models

## IFunction

  - has
    - parameterNames
    - code
  - does
    - transformPoint [x, y] -> [x1, y1]
  - hasMany
    - Transorms

## Transform

  - has
    - parameterValues
  - belongsTo
    - IteratedFunction
    - System

## IFSystem

  - extends(?) EventEmitter
  - has
    - name
  - hasMany
    - Transforms
  - does
    - renderFrame
  - emits
    - 'done'

# Instances

## linearTransform

  - is IteratedFunction
  - sets
    - parameterNames = [...]
    - code
