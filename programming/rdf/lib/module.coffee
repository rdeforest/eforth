comment = """
    Goals:
      * low-friction
        * dependency injection
        * self-documentation
        * principle of least surprise

    Conforming modules
      * respect community expectations up to a point:
        * ('rdf/module').require 'module' returns something "normal"

  """

usage = """
  require('rdf/lib/module').defineModule
    defaults: {} # optional
    export = ({imports, options}) ->
    optionalPreDefine = ({require, options}) ->
"""

exports = (opts, make, prepare = ->) ->
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

  expression if predicate

  expression for varname      in iterable
             for varname, idx in iterable
             for varname, idx from iterable

  iterable[Symbol.iterator] isnt undefined


  expression while predicate

Object.assign exports,
  { usage
    comment
    exports
  }
