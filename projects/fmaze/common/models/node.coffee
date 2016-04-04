module.exports = (Node) ->
  Node.prototype.connect = (to, bothWays) ->
    {Edge} = Node.app.models

    new Promise (resolve, reject) =>
      edgeInfo =
        fromId: @getId()
        toId: to.getId()

      Edge.find where: edgeInfo
        .then ([found]) =>
          if found
            return found
          else
            Edge.create edgeInfo

        .then (e1) =>
          if bothWays
            to.connect this
              .then (e2) => resolve [e1, e2]
          else
            resolve [e1]
