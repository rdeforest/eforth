concat = (a, b) -> a.concat b

arrangeArgs = (arranger, fn) -> (args...) -> fn arranger(args)...

swapNthAndMth = (n, m) -> (args...) ->
  newArgs = args.slice()
  newArgs[n] = args[m]
  newArgs[m] = args[n]
  newArgs

swap = swapNthAndMth 1, 2

lastToFirst = (args...) -> args[-1..][0].concat args[1..]
