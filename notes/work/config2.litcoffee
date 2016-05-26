# The shoulders of giants...

    _ = require 'underscore'
    moment = require 'moment'

# Everything should have a description

    class Described
      constructor: (info) ->
        {@desc} = info

# The concept of a hierarchy keeps coming up...

    class Tree extends Described
      constructor: (info) ->
        super info
        {@parent} = info
        @_Tree = kids: = []

      hasAncestor: (ancestor) ->
        ancestor is this or @parent?.hasAncestor ancestor

      addChild: (kid) ->
        if not (kid in @_Tree.kids)
          @_Tree.kids.push kid

      removeChild: (kid) ->
        if -1 < idx = @_Tree_kids.indexOf kid
          @_Tree.kids.splice idx, 1

      ancestors: ->
        if @parent
          @parent.ancestors().concat [this]
        else
          [this]

      children: -> _.union [], @_Tree.kids

      descendents: ->
        kids = @children()
        kids.concat _.flatten kids.map (kid) -> kid.children()

# Trees of Named Things

Many (most?) config selector values are nodes of hierarchies: locations, host
types, team, etc. In that case, children of a key are the same as that key for
matching purposes.

    class NameTree extends Tree
      constructor: (info) ->
        super info

        {@name} = info

# A configuration is a default map and overrides

    class Config extends Tree
      constructor: (info) ->
        super info

        {basedOn = {}} = info

        @_Config =
          basedOn: basedOn
          cachedBase: _.extend {}, basedOn.current(), fetched: moment()
          overrides: {}

      get: (key) ->
        

# Special cases override the match function

      matchesContext: (context) -> true

      get: (key, context) ->
        if @matchesContext context and Object.hasOwnProperty @_Config_data, key
          return @_Config_data[key]

        if @parent
          return @parent.get key, context
        
        return undefined

      set: (key, value) ->
        @_Config_data[key] = value

    class AspectedConfig extends Configuration
      constructor: (info) ->
        super info

        {@aspect, @aspectKey} = info

      matchesContext: (context) ->
        context[@aspect]?.hasAncestor @aspectKey
        
# Usage...

What would it look like to use this thing? heh.


    # config = require 'this file'

    {Config, ConfigTemplate} = config

    Customer = ConfigTemplate.create
      require:
        name: "string"
      optional:
        consuming: [ "string" ]
