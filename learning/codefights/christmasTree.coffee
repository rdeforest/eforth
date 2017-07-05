align = (lines) ->
  console.log lines
  trunkPositions =
    lines.map (l) -> (l.length - 1) / 2 + 1

  console.log longest = trunkPositions[..].sort((a, b) -> b - a)[0]
  console.log trunkPositions

  lines
    .map (l, i) ->
      " ".repeat(longest - trunkPositions[i]) + l

treeLevel = (level, levelHeight) ->
  topWidth = (level - 1) * 2 + 5

  [1..levelHeight]
    .map (line) ->
      "*".repeat topWidth + (line - 1) * 2

levels = (levelNum, levelHeight) ->
  [1..levelNum]
    .map (level) -> treeLevel level, levelHeight
    .reduce (a, b) -> a.concat b

trunk = (levelNum, levelHeight) ->
  line = "*".repeat levelHeight + 1 - levelHeight % 2
  [1..levelNum].map -> line

module.exports =
  christmasTree = (levelNum, levelHeight) ->
    tree = ["*", "*", "***"]
      .concat levels levelNum, levelHeight
      .concat trunk  levelNum, levelHeight

    align tree
