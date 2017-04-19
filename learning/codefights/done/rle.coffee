lineEncoding = (s) ->
  s.match /((.)\2*)/g
    .map (ss) ->
      if ss.length is 1
        ss
      else
        ss.length + ss[0]
    .join ''

console.log lineEncoding 'aabbbc'
