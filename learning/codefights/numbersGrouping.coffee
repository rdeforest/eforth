# You are given an array of integers that you want distribute between several
# groups. The first group should contain numbers from 1 to 10^4, the second
# should contain those from 10^4 + 1 to 2 * 10^4, ..., the 100th one should
# contain numbers from 99 * 10^4 + 1 to 10^6 and so on.
# 
# All the numbers will then be written down in groups to the text file in such a
# way that:
# 
# - the groups go one after another;
# - each non-empty group has a header which occupies one line;
# - each number in a group occupies one line.
# 
# Calculate how many lines the resulting text file will have.

module.exports.numbersGrouping = numbersGrouping = (numbers) ->
  groups = []
  gCount = 0

  for n in numbers
    gId = n - (n - 1) % 10000

    unless groups[gId]
      gCount++
      groups[gId] = 1

    #console.log n, gId, groups

  numbers.length + gCount
