# Enter potential passwords, one per line. 
# End with a blank line.
# Script will recommend picks.
# Enter number of correct letters to get next recommendation.

Hack = require './hack'

options = []

lineHandlers =
  getPassOptions: null
  getPassGuess: null

modes =
  wordEntry: (rl) ->
    writeln 'Enter password options, one per line. Enter a blank line when done.'
    rl.setPrompt 'add word> '
      .on 'line', getPassOptions

  guessing: (rl) ->
    writeln 'Enter a guess and proximity'
    rl.setPrompt 'guess> '
      .on 'line', getPassGuess

handlers.getPassOptions = (l) ->
  if l.length
    if options.length and l.length isnt options[0].length
      return writeln 'Ignored: all potential passwords must be same length.'

    options.push l
  else
    rl.on 'line', modes.guessing rl
    makeSuggestion()

handlers.getPassGuess = (l) ->
  [word, prox] = l.split ' '
  if prox is word.length
    writeln 'Congradulations!'
    process.exit 0

readline = require 'readline'
write = stdio.write
writeln = (s) -> write s + '\n'
writelns = (ll) -> writeln ll.join '\n'

rl = readline.createInterface()

modes.wordEntry rl

