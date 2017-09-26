CoffeeScript = require 'coffee-script'

module.exports = (IFunction) ->
  IFunction.prototype.compile = ->
    @code()
      .then (code) ->
        @compiled = eval CoffeeScript.compile "return (#{code})"

  IFunction.prototype.transform = (vector) ->
    @compiled {vector, @params}
