_ = require 'underscore'

module.exports = ConfigTemplate

addLazyValue = (o, name, generator, dependencies = {}) ->
  p = {}
  compute = ->
    try
      success: generator dependencies
    catch e
      if e.message.match /^Incomplete/
        return pending: true
      else
        return error: err

  resolved = false
  promise = new Promise (resolve, reject) -> _.extend p, {resolve, reject}

  Object.defineProperty o, name,
    get: -> promise
    set: (value) ->
      if resolved
        return promise

      _.extend dependencies, value
      {success, pending, error} = compute()

      if error
        resolved = true
        promise.reject error
      else if not pending
        resolved = true
        promise.resolve success

      return promise


class ConfigTemplate
  constructor: (conf = {}) ->
    _.extend @conf, @constructor.defaults or {}, conf

  expand: (params) ->
    new PotentialConfig this, params

ConfigTemplate.defaults = {}

class PotentialConfig
  constructor: (@template = new ConfigTemplate, @params = {}) ->

class ActualConfig
  constructor: (@template, @known) ->

  deriveParams: ->

  compare: (potentialConfig) ->

class ConfigElement
  constructor: (@known = {}) ->
    @derived = {}

  generate: (values) ->
    throw new Error 'virtual method needs concrete implementation'

  derive: ->
    throw new Error 'virtual method needs concrete implementation'

class ConfiguredDirectory extends ConfigElement
  generate: (values) ->
