electionsWinners = (counted, uncounted) ->
  winners = 0
  leader = Math.max counted...
  leaders = 0

  for n, i in counted
    m = n + uncounted

    if m is leader
      leaders++
    else if m > leader
      winners++

  if winners
    winners
  else if leaders is 1
    1
  else
    0

console.log electionsWinners [2,3,5,2], 3

console.log electionsWinners [5,1,3,4,1], 0
