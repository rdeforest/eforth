CoffeeScript = require 'coffee-script'

class Method
  @comment: """
    I implement AOmethods.
  """

  constructor: (@context, @code) ->
    @ast = CoffeeScript.compile @code

module.exports = {Method}
