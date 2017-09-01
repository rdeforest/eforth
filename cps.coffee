# first some Continuation Passing Style utility...

ifElse = (pred, trueBlock, falseBlock, ret) ->
  return pred (pVal) ->
    ( if pVal
        trueBlock
      else
        falseBlock
    ) ret

whileTrue = (pred, block, ret) ->
  _nextIter = (acc = [], ret) ->
    return ifElse pred,
      (-> block (blockResult) -> _nextIter [acc..., blockResult], ret),
      (-> ret acc),
      ret

  return _nextIter ret

forArray = (block, array, ret) ->
  _nextIter = (array, acc = [], ret) ->
    ifElse ((ret) -> ret array.length),
      (-> block array[0], (blockResult) -> _nextIter array[1..], [acc..., blockResult], ret)
      (-> ret acc)

  return _nextIter array, ret

module.exports = {ifElse, whileTrue, forArray}
