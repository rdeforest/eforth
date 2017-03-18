unless 'function' is typeof Object.hasOwnProperty
  Object.defineProperty Object, 'getOwnPropertyDescriptors',
      configurable: true,
      writable: true,
      value: (object) ->
        Reflect.ownKeys(object).reduce((descriptors, key) ->
          Object.defineProperty descriptors, key,
              configurable: true,
              enumerable: true,
              writable: true,
              value: Object.getOwnPropertyDescriptor(object, key)
          ), {}


deepCopyObject = (o) ->
  proto = Object.getPrototypeOf f
  copy = {}

  if Array.isArray o
    copy = []

  if 'function' is typeof o
    if not (parts = functionParts o)
      throw new Error "wtf, .toString() output didn't match?"

    {name, isNative} = parts

    args = [..f.length - 1].map((n) -> "a#{n}").join ","
    copy = eval "function #{name}(#{args}) { f.apply(this, arguments) }"

  Object.setPrototypeOf copy, proto

  (copy[k] = deepCopy o[k]) for k in Reflect.ownKeys o

functionParts = (f) ->
  if parts = (f.toString()).match /^function ([^(]*)[(][^)]*[)] { (.*) }/
    [ whole, name, args, code ] = parts
    isNative = code is '[native code]'

    return {name, args, code, isNative}

deepCopy = (v) ->
  switch typeof v
    when 'function', 'object' then deepCopyObject v
    else v

module.export = deepCopy
