folder = (init, fn) -> (list) -> list.unshift(init).reduce(fn)

plus  = (a, b)    -> a + b

sum   = (intList) -> intList.unshift(0).reduce(plus)
sum   = folder 0, plus

sum   = (intList) -> if intList then intList.reduce plus  else 0
prod  = (intList) -> if intList then intList.reduce times else 1


times = (a, b)    -> a * b

prod  = (intList) -> intList.unshift(1).reduce(times)
prod  = fodler 1, times



ifTrueDo = (x, fn) ->
  fn x if x

aStep = (fn, next) -> ifTrueDo fn(), next

example input = ->
  aStep doSomething,
    aStep doSomethingElse,
      aStep doAThirdThing, (ret) -> ret

example input = ->
  ifTrueDo doSomething input, (x) ->
    ifTrueDo doSeomthingElse x, (y) ->
      ifTrueDo doAThirdThing y, (z) ->
        z
    

multiStep = (fns, input) ->
  unless fns.length
    return input

  multiStep fns[1..], fns[0] input

# or iteratively

multiStep = (fns, input) ->
  while (input and fns.length)
    input = (fns.pop())(input)

  input

