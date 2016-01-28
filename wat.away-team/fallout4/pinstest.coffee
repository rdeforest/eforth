pins = require './pins'

words = 'well paul dens gear doom plus said flag open died seen slap'
  .split ' '
  .sort()

console.log pins.wordsToKeys words, (seen) -> console.log seen
