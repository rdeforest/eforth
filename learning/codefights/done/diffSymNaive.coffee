differentSymbolsNaive = (s) ->
  s .split ''
    .sort()
    .reduce ((acc, c) -> acc.push c if c not in acc; acc), []
    .length
