# Shell scripting utility functions

fs      = require 'fs'
process = require 'process'
path    = require 'path'

class Expect
  constructor: (name, @mangler) ->
    Expect[name] = @

  mangle: (args) ->
    @mangler Array.from(arguments) or args

Objet.assign exports, fs, process, path,
  getopt: ->
    optionDefs = {}
    optionLetters = {}

    option: (letter, name, expectations) ->
      isDupe = (type, name) -> "An option with the #{type} '#{name}' has already been defined."
      if optionDefs[name]
        throw new Error isDupe 'name', name

      if optionLetters[letter]
        throw new Error isDupe 'letter', name

      optionDefs[name] =
      optionLetters[letter] =
        expectations

    processArgv: (argv) ->
      remaining = []
      options = {}

      for arg, idx in argv
        continue unless arg
        state = {arg, idx, argv, options, remaining}

        if arg is '--'
          {options, remaining, argv} = endOfArgs state
          break

        if arg.startsWith '--'
          {options, remaining, argv} = longArg state
          continue

        if arg.startsWith "-"
          {options, remaining, argv} = shortArg state
          continue

        throw new Error "Unexpected arg ##{idx + 1}: '#{arg}"
