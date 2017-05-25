process  = require 'process'
readline = require 'readline'

console.log 'loading dictionary...'

prefixes = {}
suffixes = {}

words = (require 'fs')
  .readFileSync '/usr/share/dict/words'
  .toString()
  .split '\n'
  .filter (w) -> w.match /^[a-z]+$/

console.log "Loaded #{words.length} words."

ui = readline.createInterface
  input:    process.stdin
  output:   process.stdout
  terminal: true
  prompt:   'suffix or / cmd > '
ui.prompt()

commands =
  '?': doHelp

  score: ->
    scores = []

    for suffix, prefixedWith of suffixes
      p = prefixedWith.size
      total = 0

      for prefix, suffixedWith of prefixes
        total += p ** 2

      scores.push { suffix, p, score: total }

    for {suffix, p, score} in scores.sort((a, b) -> a.score - b.score)
      console.log suffix, p, score

  suffixes: ->
    console.log w for w of suffixes

  prefixes: ->
    table =
      Object.entries prefixes
        .map ([prefix, users]) -> { length: prefix.length, count: users.size, prefix, users }
        .filter ({count}) -> count > 1
        .sort (a, b) -> a.count - b.count

    console.log "#{table.length} prefixes"

    longest = table.reduce ((longest, {length}) -> Math.max longest, length), 0

    table.forEach ({length, count, prefix, users}) ->
      users = (w for w from users)

      console.log "#{" ".repeat longest - length}  #{prefix}: [#{users.length}] #{users.join(', ').substr 0, 80}"

    console.log()

ui.on 'line', (line) ->
  switch
    when not line.length                          then null
    when cmd = matchCommand line                  then cmd line
    else                                               doHelp line
  ui.prompt()

matchCommand = (line) ->
  [cmd, args...] = line.split /\s+/

  switch
    when not args.length and cmd.match /^[a-z]+/      then doSuffix
    when 'function' is typeof fn = commands[cmd]      then fn
    when cmd.length <= 1                              then false
    when 'function' is typeof fn = commands[cmd[1..]] then fn
    else                                                   doHelp

doSuffix = (suffix) ->
  if suffixes[suffix]
    return console.log "Already did that one."

  novel = 0
  suffixes[suffix] =
  matchingPrefixes =
    words
      .filter (w) -> w isnt suffix and w.endsWith suffix
      .map (w) -> w[0..-1 - suffix.length]

  for prefix in matchingPrefixes
    if not prefixes[prefix]
      prefixes[prefix] = new Set
      novel++

    prefixes[prefix].add suffix
    console.info "#{prefix} #{prefixes[prefix].size}"

  console.log "#{matchingPrefixes.length} prefix(es), #{novel} were new"
  ui.setPrompt "#{Object.keys(prefixes).length} prefixes, #{Object.keys(suffixes).length} suffixes > "

doHelp = (line) ->
  console.log """
    Enter a suffix to search for matching words and add their prefixes to the
    library. Start a line with a slash to execute a command:

      /prefixes [pattern] - show identified prefixes, ordered by frequency
      /suffixes [pattern] - show entered suffixes ordered by number of prefixes found
      /infer     prefix   - search for words with the given prefix and
                            process them as if they were entered.

  """

