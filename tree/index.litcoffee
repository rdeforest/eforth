# UTILITY!

    _ =
      flatten: (lists) ->
        if not Array.isArray(lists)
          return lists
        else if 'object' isnt typeof lists[0]
          return [lists[0]].concat _.flatten lists.splice 1
        else
          return lists[0].concat _.flatten lists.splice 1

# A tree has a value, children and an optional parent

    class Tree
      constructor: (info) ->
        {@value, @children = [], @parent} = info

      ancestors: ->
        if @parent
          @parent.ancestors().concat [this]

        else
          [this]

      descendents: ->
        _.flatten @children.map (child) -> child.descendents()

      visitKidsDepthGather: (fn) ->
        results =
          for child in @children
            child.visitKidsDepthGather fn

        results.concat [fn this]

      visitKidsDepth: (fn) ->
        for child in @children
          child.visitKidsDepth fn

        fn this
        return

      descendentsBreadth: ->
        kids = [this]
        decendents = []

        while kids.length
          descendents.push kid = kids.shift()
          kids.concat kid.children

        decendents
