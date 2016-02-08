###

New idea: still requires eval, and the eval has to be re-applied to update the
macro list, but that might be ok.

Macro generation looks like

enhancedFunction = provideMacros macroObj, fn

provideMacros composes and evals the source of a function which defines vars
for the provided macros and includes the provided function's definition as a
return value so that references to the macros in the inner function resolve to
the outer function's definitions.

The resulting function object then gets a .updateMacros method added to it
which does what it says on the tin.

###

provideMacros = (macroObj, fn) ->
  evalSuffix = "return " + fn.toString() + "})()"
  evalPrefix = "(function(macroValues) {"
  ...

###

An experiment in trying to reproduce Lisp's macro functionality.

Use case:

    ...

Intuition

  - Only possible with eval or some other full-access code creation mechanism
  - Needs to operate on ASTs
    - Which implies we'll have to use a JavaScript parser, integrate with CoffeeScript, etc
    - This is where Lisp fans point and laugh :/

###

module.exports = class MacroMaker
  constructor: (@macros = {}) ->

  addMacro: (name, value) ->
    @macros[name] = value

  wrapCode: (code) ->
    """
      ( ->
        #{@macroDefinitions()}

        #{code}
      )()

    """

  macroDefinitions: ->
    def = ''
    def += "@#{name} = #{JSON.stringify value}\n" for name, value of @macros
    def

