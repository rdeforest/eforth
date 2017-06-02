module.exports =
  electionsWinners = (votes, pending) ->
    baseMax = Math.max votes...
    if not pending then baseMax--

    canWin = votes
      .filter (secured, candidate) -> secured + pending > baseMax
      .length

    if not pending and canWin > 1
      0
    else
      canWin
