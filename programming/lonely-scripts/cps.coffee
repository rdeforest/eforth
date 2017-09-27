
# Binding 'ret' to 'this' makes the innards of CPS functions clearer (to me)

isCPS = Symbol "Function's last arg is a function"

# To terminate a CPS chain, pass identity
# as the ultimate destination for the result.

identity = (i) -> i

# Alias for documentation purposes
dropStack = (fn) -> setTimeout fn

o = (fn) ->
  if fn[isCPS]
    throw new Error "Re-wrapping is pointless and implies an error"

  if 'function' isnt typeof fn
    throw new Error "Attempt to wrap non-function"

  bound = ->
    ret = arguments[arguments.length - 1]

    if 'function' isnt typeof ret
      ret = console.log

    fn.apply ret, arguments

  bound[isCPS] = true # for debugging's sake
  bound

cpsToPromise = (cpsFn) ->
  (args...) ->
    new Promise (resolve, reject) ->
      cpsFn args..., (ret, err) ->
        if arguments.length is 2
          reject  err
        else
          resolve ret

# ((cpsToPromise incr) 1)
#   .then (onePlus) -> console.log onePlus

# All CPS from here on down!

incr = o (n) -> @ n + 1
decr = o (n) -> @ n - 1

log  = o (args...) -> console.log(args...); @ args...

# 'incr 1, log' emits 2

confirmCPS = o (fns...) ->
  for fn in fns when 'function' isnt typeof fn or not fn[isCPS]
    return @ null, fn

  @ fns

ifElse = o (pred, trueBlock, falseBlock) ->
  confirmCPS pred, trueBlock, falseBlock, (ok, err) ->
    switch err
      when pred       then @ null, "nonCPS predicate passed to ifElse"
      when trueBlock  then @ null, "nonCPS trueBlock passed to ifElse"
      when falseBlock then @ null, "nonCPS falseBlock passed to ifElse"
      else _ifElse pred, trueBlock, falseBlock, @

_ifElse = o (pred, trueBlock, falseBlock) ->
  pred (predTrue) ->
    ( if predTrue
        trueBlock
      else
        falseBlock
    ) @

whileTrue = o (pred, block) ->
  confirmCPS pred, block, (ok, err) ->
    thrower = (msg) -> @ null, msg

    switch err
      when undefined, null then _whileTrue pred, block, @
      when err is pred     then thrower "nonCPS predicate passed to whileTrue"
      when err is block    then thrower "nonCPS block passed to whileTrue"
      else                      thrower err

_whileTrue = o (pred, block) ->
  ( _nextIter = o (acc = []) ->
      _ifElse pred,
        (o -> block (blockResult) -> _nextIter acc.concat(blockResult), @),
        (o -> @ acc),
        @
  ) @

forArray = o (block, array) ->
  unless Array.isArray array
    return @ null, "non-array passed to forArray"

  confirmCPS block, (ok, err) ->
    return @ null, err if err

    _forArray block, array, @

_forArray = o (block, array, ret) ->
  _nextIter = (array, acc = [], ret) ->
    ifElse ((ret) -> ret array.length),
      (-> block array[0], (blockResult) -> _nextIter array[1..], [acc..., blockResult], ret)
      (-> ret acc)

  return _nextIter array, ret

missing = Symbol "arg not provided"


defRangeStep = (from, to, ret) ->
  ifElse ((ret) -> greaterOrEqual from, to, ret),
    ((ret) -> ret decr),
    ((ret) -> ret incr),
    ret


range = (from, to, inc = missing, ret) ->
  ifElse ((ret) -> inc is missing),
    (-> defRangeStep from, to, (inc) -> _range from, to, inc, ret),
    (->                                 _range from, to, inc, ret),
    ret
    
add  = o (x, y) -> @ x + y
mul  = o (x, y) -> @ x * y
sqrt = o (x   ) -> @ Math.sqrt x
sqr  = o (x   ) -> @ x * x

pyth = o (x, y) ->
  ret = @

  sqr x, (xs) ->
    sqr y, (ys) ->
      add xs, ys, (summed) ->
        sqrt summed, ret

pipe = o (steps...) ->
  _nextStep = o ([step, steps...], soFar) ->
    next = o (result) -> _nextStep steps[1..], result

    ifElse (o -> @ steps.length),
           (o -> steps[0] result, next),
           (o -> @ soFar),
           @

keepAndThen = o = (andThen, a) ->
  andThen o (b) ->
    @ [a, b]

pyth2 = o (x, y) ->
  pipe [
    o -> sqr x
    keepAndThen o -> sqr y
    add
    sqrt
  ] @

Object.assign global, module.exports = {cpsToPromise, ifElse, whileTrue, forArray, range, o, add, mul, sqrt, sqr, pyth}

