changeOfVowelsInCycle = (cycle, text) ->
  vowels = []; n = 0

  text.split ''
    .reverse()
    .map (c) -> console.log c; c
    .map (c, i) -> vowels.push c if c in "aeiou"; c
    .map (c, i) -> if c not in "aeiou" then c else vowels[(n += cycle) % vowels.length]
    .join ''


