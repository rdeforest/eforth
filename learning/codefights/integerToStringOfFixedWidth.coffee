module.exports =
  integerToStringOfFixedWidth = (n, width) ->
    str = n.toString()
    diff = width - str.length

    switch
      when diff is 0 then str
      when diff > 0 then  '0'.repeat(diff) + str
      when diff < 0 then str[-diff..]
