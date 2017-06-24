module.exports =
  characterParity = (symbol) ->
    switch
      when symbol in '02468'.split '' then 'even'
      when symbol in '13579'.split '' then 'odd'
      else                                 'not a digit'
      
