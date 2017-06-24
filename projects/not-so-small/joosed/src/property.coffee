###

A PropertyDescriptor describes and manages a specific future, current or past
property definition on a klass.

Properties have optional validation and maybe other features in the future?

###

module.exports =
  class PropertyDescriptor
    constructor: (@definer, @name, opts = {}) ->
      { @validator = null
        @mode      = 'rw'
        @readable  = @mode.includes 'r'
        @writeable = @mode.includes 'w'
        @isa       = 'any'
      } = opts

      if 'string' isnt typeof @definer?.name or definers[@definer.name] isnt @definer
        throw new Error "Property definers must have a unique .name"

      @definers[@definer.name] = @definer

    valid: (v) ->
      (@isa in [ 'any', typeof 'v'] or v instanceof @isa) and
        @validator v

    addToDefiner: ->

    removeFromDefiner: ->


