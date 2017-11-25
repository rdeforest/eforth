class Store
  constructor: ->
    if @constructor is Store
      throw new Error "Cannot instantiate abstract class 'Store'"

  get: (uuid) -> throw new Error "Virtual method 'get' not overriden in #{@constructor.name}"
  put: (uuid) -> throw new Error "Virtual method 'put' not overriden in #{@constructor.name}"
  has: (uuid) -> throw new Error "Virtual method 'has' not overriden in #{@constructor.name}"
  ids:        -> throw new Error "Virtual method 'ids' not overriden in #{@constructor.name}"

Object.assign module.exports, { Store }

