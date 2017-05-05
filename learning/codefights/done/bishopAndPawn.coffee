bishopAndPawn = (pieces...) ->
  [bishop, pawn] = pieces.map (p) ->
    [" abcdefgh".indexOf(p[0]), parseInt p[1]]

  Math.abs(bishop[0] - pawn[0]) is Math.abs(bishop[1] - pawn[1])
