qw = (s) -> s.split /\s+/g

module.exports =
  usage: usage = new Error """
    Usage:

    (require 'trinket')
      .create
        name: "Example"
        domain: "example.com"
        ...
  """

  create:
    CreateTrinket = (callerExports, info) ->
      throw usage unless info and validate info
      info = setDefaults info

      trinket = callerExports[name] =
        makeFunction info

      CreateTrinket # for chaining

  # find converts a string or object mapping to the trinket namespace into an
  # object which can be treated as a factory for that trinket.
  find: (reference) ->

isString = (s) -> ('string' is typeof a) or (a instanceof String)
isArray = Array.isArray

ARG_VALIDATORS =
  name:           isString
  domain:         isString
  version:        isString
  implementation: isArray

ARG_DEFAULTS =
  TrinketVersion:        -> "1.0"
  parameters:     (args) -> {}
  constants:      (args) -> {}
  output:         (args) -> {}

validateAndSetDefaults = (orig) ->
  info = {}

  for name, isValid of ARG_VALIDATORS
    return false unless isValid info[name]

    info[name] = orig[name]

  true

setDefaults = (orig) ->
  info = {}

  for name, value of ARG_DEFAULTS
    info[name] = orig[name] ? value orig

  for name of ARG_VALIDATORS

  info

makeFunction = (info) ->
  { dependencies
    constants
    parameters
    implementation
  } = info

  resolved = resolveDependencies dependencies
  steps = convertImplementation implementation
  argProcessor = makeArgProcessor parameters

  fn = ->
    state = {}
    args = argProcessor arguments

    for step in steps
      newState = step state, Object.assign {}, args
      state = newState ? state

    return

  fn.meta = info
  fn

convertStep = (dependencies, constants, parameters, step) ->
  [trinketName, extraKeys...] = Object.keys step

  if extraKeys.length
    throw new Error "Invalid step has extra top-level keys: " + JSON.stringify step

  trinketArgs = step[trinketName]
  trinket = resolved[trinketName]

  (state, args) ->
    trinket
    

convertImplementation = (steps) ->
  steps.map convertStep
