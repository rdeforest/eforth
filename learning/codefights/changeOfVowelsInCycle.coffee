changeOfVowelsInCycle = (cycle, text) ->
  letters = text.split('').reverse()
  vowels = letters.filter (c) -> c in "aeiouAEIOU"

  if not cycle = (cycle * vowels.length - cycle) % vowels.length
    return text.split('').reverse().join('')

  console.log cycle.toString() + "\n", vowels, "\n",
    vowels = vowels[cycle ..].concat vowels[.. cycle - 1]

  letters
      .map (c, i) -> if c not in "aeiouAEIOU" then c else vowels.shift()
      .join ''

# (require './test') [
#   [ 1, 'potato', 'ototap' ]
#   [ 3, 'this test is of potato', 'itetip fo sa tsot soht']
#   [10, 'Ojf lsnelI UFlsn Eeiuo nnky Ynak jhA', 'ahj konY yknn uieEU nslFI elOnsl fjA' ]
# ], changeOfVowelsInCycle
