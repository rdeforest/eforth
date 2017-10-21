readline        = require 'readline'
{stdin, stdout} =
process         = require 'process'
fs              = require 'fs'

letters =
  'abcdefghijklmnoprstuvwxyz'
    .split ''
    .concat 'qu'

attacksToShow = 10

filters = null

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
    .filter validTile

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

validAttack = (word, filters) ->
  word.toLowerCase()

  remaining = Array.from tiles
  wordsTiles = wordTiles[word]

  for tile in wordsTiles
    return false if -1 is idx = remaining.indexOf tile

    remaining.splice idx, 1

  if filters
    for tile in filters.required  when tile not in wordsTiles
      console.log "excluding #{word} for lacking #{tile}"
      return false

    for tile in filters.prohibited when tile in wordsTiles
      console.log "excluding #{word} for having #{tile}"
      return false

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

topAttacks = (max = 10, filters) ->
  found = 0
  ( for word in words when validAttack word, filters
      break unless found++ < max
      "#{wordScore(word).toString().padEnd 2} #{word}"
  ) .join "\n"

# console.log "#{attacks.length} likely valid attacks found\n"

makePrompt = ->
  sections = [ "Tiles:\n#{showTiles()}" ]

  if (howMany = needed()) > 0
    sections.push "Need #{howMany} more letters  > "
  else
    if filters
      sections.push "Filters require #{filters.required} and prohibit #{filters.prohibited}"

    sections.push "Top #{attacksToShow} attacks:\n#{topAttacks attacksToShow}\nattack > "

  sections.join '\n'


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

###

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

###

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

setFilters = (line) ->
  filters =
    required: []
    prohibited: []

  mode = 'required'

  for char in line
    switch char
      when '+' then mode = 'required'
      when '-' then mode = 'prohibited'
      else filters[mode] = filters[mode].concat wordToTiles(char)

setAttacksToShow = (line) ->
  if matched = line.match /\d+/
    if 0 < n = parseInt matched[0]
      attacksToShow = n
    else
      attacksToShow = 10

processLine = (line) ->
  line = line.toString()

  switch
    when line.startsWith '#'        then setAttacksToShow line
    when line.startsWith '?'        then setFilters line
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

Object.defineProperty module.exports, 'addTiles',           get: -> addTiles
Object.defineProperty module.exports, 'fiveLetterWords',    get: -> fiveLetterWords
Object.defineProperty module.exports, 'letters',            get: -> letters
Object.defineProperty module.exports, 'makePrompt',         get: -> makePrompt
Object.defineProperty module.exports, 'minigame',           get: -> minigame
Object.defineProperty module.exports, 'needed',             get: -> needed
Object.defineProperty module.exports, 'processAttack',      get: -> processAttack
Object.defineProperty module.exports, 'processLine',        get: -> processLine
Object.defineProperty module.exports, 'qToQu',              get: -> qToQu
Object.defineProperty module.exports, 'rankedCandidates',   get: -> rankedCandidates
Object.defineProperty module.exports, 'setPrompt',          get: -> setPrompt
Object.defineProperty module.exports, 'setTiles',           get: -> setTiles
Object.defineProperty module.exports, 'showTiles',          get: -> showTiles
Object.defineProperty module.exports, 'sortWords',          get: -> sortWords
Object.defineProperty module.exports, 'tileValue',          get: -> tileValue
Object.defineProperty module.exports, 'tiles',              get: -> tiles
Object.defineProperty module.exports, 'topAttacks',         get: -> topAttacks
Object.defineProperty module.exports, 'validAttack',        get: -> validAttack
Object.defineProperty module.exports, 'validMasterGuesses', get: -> validMasterGuesses
Object.defineProperty module.exports, 'validTile',          get: -> validTile
Object.defineProperty module.exports, 'validWord',          get: -> validWord
Object.defineProperty module.exports, 'wordScore',          get: -> wordScore
Object.defineProperty module.exports, 'wordTiles',          get: -> wordTiles
Object.defineProperty module.exports, 'wordToTiles',        get: -> wordToTiles
Object.defineProperty module.exports, 'words',              get: -> words
