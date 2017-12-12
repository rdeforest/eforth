comment = """
  Goals:
    * low-friction
      * dependency injection
      * self-documentation
"""

usage = """
  require('rdf/lib/module').defineModule
    defaults: {} # optional
    export = ({imports, options}) ->
    optionalPreDefine = ({require, options}) ->
"""

defineModule = (opts, make, prepare = ->) ->
  if 'function' is typeof opts
    [make, prepare = ->] = [opts, make]

  if 'function' isnt typeof make
    throw new Error "Usage: #{usage}"

  imports = {}
  options = {}

  # Wrapper is called (once) by Node require()
  wrapper = (userOptions = {}) ->
    finalOptions = merge options, userOptions
    make imports, finalOptions

Object.assign exports,
  { usage
    comment
    defineModule
  }
