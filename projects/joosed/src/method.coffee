###

A MethodDescriptor describes and manages a specific future, current or past
method definition on a klass.

###

module.exports =
  class MethodDescriptor
    @definersOf: {}

    constructor: (@definer, @name, @fn, @opts = {}) ->
      (@definersOf[@name] ?= []).push @

    canAddToObject: (target) ->
      if defined = target.lookupMethod @
        if defined.definer is target
          return @replaceMethodOn target

        if defined.final
          throw new Error "Cannot override final method #{@name}"

      if @final
        for definer in MethodDescriptor.definersOf[definer.name]
          if definer.hasAncestor @definer
            throw new Error "Cannot add final method that is already overriden in a child"

    install: (meta) ->
      meta.does[@name] = @
      @definer::[@name] = 
      
    destroy: ->
      @definer.removeMethod @

      @definersOf[@name] =
        @definersOf[@name]
          .filter (def) -> def.definer isnt @definer


