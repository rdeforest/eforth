knapsackLight = (value1, weight1, value2, weight2, maxW) ->
  switch
    when (both = weight1 + weight2) <= maxW then value1 + value2
    when weight1 > maxW and weight2 >  maxW then 0
    when weight1                    >  maxW then value2
    when weight2                    >  maxW then value1
    else Math.max value1, value2
