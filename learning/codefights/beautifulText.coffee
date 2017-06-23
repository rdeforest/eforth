check = (len, s) ->
  lines = (s.length + 1) / len

  #console.log s.length, len, lines,
  chars =
    [1..lines - 1]
      .map (idx) -> s[idx]
      .filter (c) -> c isnt ' '

  if len * lines + lines - 1 isnt s.length
    return false

  return 0 is chars.length

module.exports =
  beautifulText = (s, l, r) ->
    checkBreaks = (s, len) ->
      #console.log s, len, s[len - 1]

      (s.length is len - 1) or
      ((s[len - 1] is ' ') and
      (checkBreaks s[len..], len))

    undefined isnt [l..r].find (len) ->
      checkBreaks s, len + 1

#for [args..., expected] in module.exports.tests = [
#            [ "Look at this example of a correct text", 5, 15, true ]
#            [ "abc def ghi", 4, 10, false ]
#          ]
#  result = beautifulText args...
#  console.log ["--", args, result, expected].map(JSON.stringify).join '\n'
