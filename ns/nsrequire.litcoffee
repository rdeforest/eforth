    treeSym = Symbol 'Tree'

    (require './nsdef') treeSym

    nsRequire = (root, modPath...) ->

      if tree = (require root)[treeSym]
        leaf = tree.populate modPath
      else
        throw new Error "Module '#{root}' does not have a Tree attached"

