digitSum = (n) ->
  if n < 10
    n
  else
    (m = (n % 10)) + digitSum ((n - m) / 10)

digitDegree = (n) ->
  if n < 10
    0
  else
    1 + digitDegree digitSum n

#console.log digitDegree n for n in [5, 100, 91]
