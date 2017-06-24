module.exports = (Maze) ->
  Maze.prototype.paths (from, to) ->
    mazeId = @referenceTo or @id

    if from.mazeId isnt @id or to.mazeId isnt @id
      return []


