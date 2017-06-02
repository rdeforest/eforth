alphabet = 'abcdefghijklmnopqrstuvwxyz'

module.exports =
  alphabetSubsequence = ([x,xs...]) ->
    switch
      when x not in alphabet then false
      when not xs.length then true
      when x >= xs[0] then false
      else alphabetSubsequence xs
