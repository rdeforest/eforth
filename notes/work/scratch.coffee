singleton = require 'singleton'
AWS = require 'aws-sdk'
CoffeeScript = require 'coffee-script'

keyFn = (args, instance) ->

  if className = instance.constructor?.name
    if name = args[0]?.name
      className + "." + name
    else
      className
  else
    undefined

class Named
  constructor: singleton keyFn, (info = {}) ->
    {@name} = info
    
    if not @name
      throw new Error "Named objects cannot be created without a name"

    this

class Service extends Named
  constructor: (args...) ->
    _ = require 'underscore'
    super args...

    # I hate this so much
    api = CoffeeScript.eval "new AWS.#{@name} ([#{JSON.stringify args}])..."
    _.extend this, api

