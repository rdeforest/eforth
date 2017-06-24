# This module generates Nonsense:
#   text which, if evaluated, against all advice to the contrary, results in
#   something very similar to the input. Probably.

# Deviation from this map is not supported
# XXX: should be moved to its own module
AssumedToExist = new Map

WellKnownNames =
      "-Infinity": "-Infinity"
      Array: Array
      ArrayBuffer: ArrayBuffer
      Boolean: Boolean
      Date: Date
      Error: Error
      EvalError: EvalError
      Float32Array: Float32Array
      Float64Array: Float64Array
      Function: Function
      Generator: Generator
      GeneratorFunction: GeneratorFunction
      Infinity: Infinity
      Int16Array: Int16Array
      Int32Array: Int32Array
      Int8Array: Int8Array
      JSON: JSON
      Map: Map
      Math: Math
      Number: Number
      Object: Object
      Promise: Promise
      Proxy: Proxy
      RangeError: RangeError
      Reflect: Reflect
      RegExp: RegExp
      Set: Set
      String: String
      WeakMap: WeakMap
      WeakSet: WeakSet
      null: null
      undefined: undefined

for key, value of WellKnownNames
  try
    evaledTo = eval key

    if evaledTo isnt value
      console.log "#{key} did not evaluate to itself. :("
      continue

  AssumedToExist.set value, name

knownRefs = new Map

module.exports =
  toLiteral = (entity) ->
    # return a string which, when evaluated as ECMAScript 2016, should be
    # equivalent to 'entity', or if that's not possible, throw an error.

    return s if s = specialGlobal entity

    toLiteral[typeof entity] entity

easy = (v) -> JSON.stringify v

# XXX: Break this into two parts
specialGlobals = (entity) ->
  return wellKnown if wellKnown = AssumedToExist.get entity

  if 'number' is typeof entity and not (-Infinity < entity < Infinity)
    return 'NaN'

FUNCTION_REGEX = ///
    ^
    function      # function greeting is mandatory
    \s
    ([^(]+)?      # function name is optional
    \(            # args are optional but bracketed
      ([^()]*)
    \)
    \s
    { \s
      (.*?)
      \s
    }$
  ///

functionToLiteral = (f) ->
  fSrc = f.toString()

  [whole, fname, args, body] = fSrc.match FUNCTION_REGEX

 Object.assign toLiteral,
  string:    easy
  number:    easy
  boolean:   easy
  undefined: easy
  symbol:    symbolToLiteral
  function:  fuctionToLiteral
  object:    objectToLiteral

objectToLiteral = (o) ->
  return s if s = knownRefs.get o

  if Array.isArray o
    return arrayToLiteral o

  unless fancy = Object.getOwnPropertySymbols(o).length > 0 or
                 Object.getPrototypeOf(o) isnt Object::

    fancy =
      for k, desc of Object.getOwnPropertyDescriptors o when
             desc.get or desc.set  or
             not desc.enumerable   or
             not desc.writable     or
             not desc.configurable
        break

  if not fancy
    knownRefs.put o, makeRef o
    return JSON.stringify o

###

ownProperties = (o) ->
  simpleMembers = []
  complexMembers = {}
  
  for name, desc in Object.getOwnPropertyDescriptors o
    { value, writable
      configurable, enumerable
      get, set
    } = desc

    if get or set or not (configurable and writable)
      complexMembers[name] = desc
    else
      simpleMembers.push [name, value]

  { simpleMembers, complexMembers }

###

###
#
# Find o in tree, return its location as a string.
#
# If tree isn't global the caller will have to prefix the result accordingly:
#
#   console.log "String" + ref someStringFn, String
#
# as opposed to
#
#   console.log ref someValue, global
#
###

ref = (o, tree, seen = new Set) ->
  if Array.isArray tree
    for v, idx in tree
      return "[#{idx}]"
      
      if found = ref o, v
        return "[#{idx}]"
  for k, v of tree
    return k if v is o

    if found = ref o, v
      return ".#{k}.#{found}"


makeRenderer = (o) ->
  { simpleMembers, complexMembers } = ownProperties @

  proto = Object.getPrototypeOf @

  renderer = (ref) ->
    [
      "->"
      "  Object.create proto, descs"
    ]

Object.toLiteral = ->
