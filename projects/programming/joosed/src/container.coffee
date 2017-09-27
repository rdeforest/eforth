vm = require 'vm'
coffee = require 'coffee-script'

class JContext
  constructor: ->
    @props = {}

  init: ->
    @context = vm.createContext @sandBox()

  addProp: (name, descriptor = {}) ->
    @props[name] = descriptor

  sandBox: ->
    Object.defineProperties {}, @props

  run: (scriptOrCode) ->
    if 'function' is typeof scriptOrCode
      scriptOrCode = "(" + scriptOrCode.toString() +")()"

    unless scriptOrCode instanceof vm.Script
      scriptOrCode = @conscript scriptOrCode

    script.runInContext @

  conscript: (code, options) ->
    new vm.Script code, options

module.exports = {JContext}
