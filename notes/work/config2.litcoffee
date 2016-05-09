# Everything should have a description

    class Described
      constructor: (info) ->
        {@desc} = info

# The concept of a hierarchy keeps coming up...

    class Tree extends Described
      constructor: (info) ->
        super info
        {@parent} = info
        @_Tree_kids = []

      hasAncestor: (ancestor) ->
        ancestor is this or @parent?.hasAncestor ancestor

      addChild: (kid) ->
        if not (kid in @_Tree_kids)
          @_Tree_kids.push kid

      removeChild: (kid) ->
        if -1 < idx = @_Tree_kids.indexOf kid
          @_Tree_kids.splice idx, 1

      ancestors: ->
        if @parent
          @parent.ancestors().concat [this]
        else
          [this]

# Trees of Keys

Many key values are themselves members of hierarchies: locations, host type,
team, etc. In that case, children of a key are the same as that key for
matching purposes.

    class ConfigKey extends Tree
      constructor: (info) ->
        super info

        {@name} = info

# Specific configurations inherit from more general ones

    class Configuration extends Tree
      constructor: (info) ->
        super info

        @_Configuration_data = {}

# Special cases override the match function

      matchesContext: (context) -> true

      get: (key, context) ->
        if @matchesContext context and Object.hasOwnProperty @_Configuration_data, key
          return @_Configuration_data[key]

        if @parent
          return @parent.get key, context
        
        return undefined

      set: (key, value) ->
        @_Configuration_data[key] = value

    class AspectedConfig extends Configuration
      constructor: (info) ->
        super info

        {@aspect, @aspectKey} = info

      matchesContext: (context) ->
        context[@aspect]?.hasAncestor @aspectKey
        
