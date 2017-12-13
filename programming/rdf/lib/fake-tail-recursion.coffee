recurse = (block, loopStarted) ->
  `var recurse`

  recurse  = (block) -> [null, block]
  finish   = (value) -> [value]

  nextCall = block

  loop
    [finished, nextCall] = ret = nextCall recurse, finish

    return finished if ret.length is 1

example = (lines, modulo = 256) ->
  recurse (recurse, finish) ->
    showNext = ([line, lines...], sum = 0) ->
      console.log line

      sum = (sum + line.length or 0) % modulo

      if lines.length
        recurse -> showNext lines, sum
      else
        finish sum

    recurse -> showNext lines

Object.assign exports, {recurse, example}
