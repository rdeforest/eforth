
class ExtensibleFunction extends Function
  constructor: (f) ->
    Object.setPrototypeOf f, new.target.prototype

class Smth extends ExtensibleFunction
  constructor: (x) ->
    super(-> x)
