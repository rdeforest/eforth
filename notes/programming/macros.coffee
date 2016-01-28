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

