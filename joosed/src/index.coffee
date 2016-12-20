MetaClass        = require './class'
MethodDescriptor = require './method'

defining = null

verbs =
  # isa Foo, Bar, Etc
  isa: (parents...) ->
    defining.addParent parent for parent in parents

  # has propName: is: 'rw', isa: 'string'
  has: (propertyInfo) ->
    for propName, info of propertyInfo
      definition.has[propName] = grokPropertyInfo info

  # does methName: fn: -> blah
  does: (methodInfo) ->
    for methodName, info of methodInfo
      method = new MethodDesriptor Object.assign name: methodName, info
      defining.addMethod method

  before: (methodName, fn) ->
    defining.beforeMethod methodName, fn

  after: (methodName, fn) ->
    defining.afterMethod methodName, fn

# See, this is what's neat about functional programming:
usage = ->
  throw new Error "Joosed verbs like #{verb} only work inside a JClass declaration"

for verb, def of verbs
  verbs[verb] = (args...) ->
    if defining is null
      usage verb

    def args...

JClass = (fn, reDefining = null) ->
  if defining isnt null
    throw new Error "Assumptions violated: JClass definition function must be synchronous"

  if reDefining
    defining = reDefining[jSym]
  else
    defining = new MetaClass defining

  ctx =
    Object.assign {}, verbs, self: reDefining

  (fn.bind ctx)()

  defining = null
  return defining

JClass.andThen = (klass, fn) -> JClass fn, klass

# Until I'm sure this isn't needed...
JClass.demandMetaAccess = (klass) -> klass[jSym]

export JClass
