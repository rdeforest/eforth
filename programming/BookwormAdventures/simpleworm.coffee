readline        = require 'readline'
{stdin, stdout} =
process         = require 'process'
fs              = require 'fs'

letters =
  'abcdefghijklmnoprstuvwxyz'
    .split ''
    .concat 'qu'

tileValue    = {}
tileValue[l] = 1 for l in letters
tileValue[l] = 2 for l in ['f',  'h', 'm', 'p', 'v', 'w']
tileValue[l] = 3 for l in ['j', 'qu', 'x', 'y', 'z']

validTile = (l) -> 'number' is typeof tileValue[l]

qToQu = (l) -> if l is 'q' then 'qu' else l

wordToTiles = (word) ->
  word
    .replace /qu/g, 'q'
    .split ''
    .map qToQu

validWord = (word) ->
  wordTiles = wordToTiles word

  2 < wordTiles.length <= 16 and
  -1 is wordTiles.findIndex((tile) -> not validTile tile)

wordTiles = {}

wordScore = (word) ->
  wordToTiles word
    .map (l) -> tileValue[l]
    .reduce (a, b) -> a + b

sortWords = (words) ->
  words.sort (a, b) -> wordScore(a) - wordScore(b)

words = do ->
  dict = fs
    .readFileSync '/usr/share/dict/words'
    .toString()
    .split '\n'

  sortWords(
    for word in dict when validWord word
      wordTiles[word] = wordToTiles word
      word
  ).reverse()

console.log "Found #{words.length} valid words."

tiles = []
needed = -> 16 - tiles.length

validAttack = (word) ->
  word.toLowerCase()

  remaining = Array.from tiles

  for tile in [].concat wordTiles[word]
    return false if -1 is idx = remaining.indexOf tile

    remaining.splice idx, 1

  return remaining

showTiles = ->
  [0, 4, 8, 12]
    .filter (n) -> n < tiles.length
    .map    (n) ->
      tiles[n .. n + 3]
        .filter (l) -> l
        .map (l) ->
          if not l.padEnd
            console.log "aborting on bad tile: #{tiles}"
            process.exit()

          l.padEnd 2
        .join ' '
    .join '\n'

topAttacks = (max = 10) ->
  found = 0
  ( for word in words when validAttack word
      break unless found++ < max
      "#{wordScore(word).toString().padEnd 2} #{word}"
  ) .join "\n"

# console.log "#{attacks.length} likely valid attacks found\n"

makePrompt = ->
  "Tiles:\n#{showTiles()}\n" +
    if (howMany = needed()) > 0
      "Need #{howMany} more letters  > "
    else
      "Top 10:\n#{topAttacks 10}\nattack > "


addTiles = (line) ->
  add =
    line.toLowerCase()
        .split ''
        .map qToQu
        .filter validTile

  tiles = tiles.concat add

processAttack = (line) ->
  if filtered = validAttack line
    tiles = filtered
  else
    console.log "Word #{line} cannot be made with current tiles."

setTiles = (text) ->
  tiles = text.toLowerCase()
    .split ''
    .map qToQu
    .filter validTile

fiveLetterWords = words.filter (w) -> w.length is 5

validMasterGuesses = (history) ->
  candidates = Array.from fiveLetterWords

  for [known, guess, alsoContains = []] in history
    candidates = candidates.filter (word) ->
      return false unless word.match new Regexp known

      remaining = wordToTiles word

      for l in alsoContains
        return false unless idx = remaining.indexOf l
        remaining.splice idx, 1

      true

  return candidates

rankedCandidates = (history) ->
  candidates = validMasterGuesses history
  splits = {}
  for word, idx in candidates
    splits[word] =
      matchingLetters: 0
      misplacedLetters: 0

    for otherWord in candidates[idx + 1..]
      editedWord = word

      for l in otherWord


minigame = (line) ->
  if line.contains 'master'
    firstLetter = (line.replace /master|!|\s/g, '')[0]
    history = [ [firstLetter.padEnd(5, '.')] ]

    rl.setPrompt masterGuesses history
    """Master mini-game\n
         Guesses:
       #{
         history
           .map ([known, guess, outOfPlace, wrong]) ->
             do (outOfPlace) ->
               guess
                 .map (l, i) ->
                   switch
                     when l is known[i] then l
                     when -1 isnt idx = outOfPlace.indexOf l
                       outOfPlace.splice idx, 1; '_'
                     else 'X'
          .concat (
            if outOfPlace
              "(oup: #{ outOfPlace.join ' ' })"
            else
              "")
          .join '\n    '
       }
         Top 10 recommendations:
       #{
         (rankedCandidates history)[..9]
           .map ([candidate, rank]) -> "#{rank.padStart 3} #{candidate}"
       }
       > """

processLine = (line) ->
  line = line.toString()

  switch
    when line.startsWith '!'        then minigame line
    when match = line.match /=(.*)/ then setTiles match[1]
    when needed()                   then addTiles line
    else                                 processAttack line

  setPrompt()

if require.main is module
  rl = readline.createInterface
    input: stdin
    output: stdout

  setPrompt = ->
    rl.setPrompt makePrompt()
    rl.prompt()

  rl.on 'line',       processLine
    .on 'close',   -> console.log "\nGoodbye."
    .on 'SIGTSTP', -> console.log "\nSure, I'll chill."
    .on 'SIGCONT', -> console.log "\nWelcome back."; rl.prompt()
    .on 'SIGINT',  -> console.log "\nYeah? Well screw you too!"; process.exit()

  setPrompt()

module.exports = {
  letters
  tileValue
  validTile
  validWord
  words
  tiles
  needed
  validAttack
  wordScore
  showTiles
  sortWords
  topAttacks
  makePrompt
  setPrompt
  processLine
}
