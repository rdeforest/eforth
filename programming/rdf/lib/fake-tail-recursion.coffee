fakeTailRecursion = (block, loopStarted) ->
  recurse = (block) ->
    [null, block]

  finish = (value) ->
    [value]

  nextCall = block

  loop
    [finished, nextCall] = ret = nextCall recurse, finish

    if ret.length is 1
      return finished

example = (lines) ->
  fakeTailRecursion (recurse, finish) ->
    showNext = ([line, lines...]) ->
      console.log line

      if lines.length
        recurse -> showNext lines
      else
        finish null

    recurse -> showNext lines

Object.assign exports, {fakeTailRecursion, example}
