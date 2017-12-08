# Shell scripting utility functions

fs      = require 'fs'
process = require 'process'
path    = require 'path'
assert  = require 'assert'

{ Expect } = require './expectations'

merge   = Object.assign
nop     = ->

defaultLog =
  log:   console.log
  info:  console.info
  warn:  console.warn
  error: console.error

makeGetOpts = ({logger = defaultLogger}) ->
  optionDefs    = {}
  optionLetters = {}

  getOpts =
    option: (letter, name, expectations...) ->
      isDupe = (type, name) -> "An option with the #{type} '#{name}' has already been defined."

      if optionDefs   [name]   then throw new Error isDupe 'name',   name
      if optionLetters[letter] then throw new Error isDupe 'letter', letter

      for expectation in expectations when err = expecation.validate? letter, name
        throw new Error "Error defining #{name}: #{err}"

      optionDefs   [name]   =
      optionLetters[letter] =
        {name, letter, expectations}

    processArgv: (argv) ->
      leftovers = []
      options   = {}
      nextArg   = argv[Symbol.iterator]().next

      endOfArgs = ({options, leftovers}) ->
        leftovers = leftovers.concat(value until ({value, done} = nextArg()).done)

      longArg = ({arg: option, options, leftovers}) ->
        value = null

        if matched = option.match /(.*)=(.*)/
          [all, option, value] = matched

        if not def = optionDefs[arg]
          arg = "--#{arg}"
          logger.warn "Treating unknown option '--#{arg}' as leftovers"
          options = options.concat arg
        else
          (e.apply {option, value, options, leftovers, nextArg, logger}) for e in def.expectations

      shortArgs = ({arg: letters, options, leftovers}) ->
        for letter, letterIdx in letters
          if not def = optionLetters[letter]
            logger.warn "Ignoring unknown option '-#{option}'"
            continue
          else
            for e in def.expectations
              e.processArg {letters, letterIdx, option, options, leftovers, nextArg}

      extraArg = ({arg, options, leftovers}) ->

      until ({value: arg, done} = nextArg()).done
        argType =
          switch
            when arg is '--'         then endOfArgs
            when arg.startsWith '--' then arg = arg[2..]; longArg
            when arg.startsWith '-'  then arg = arg[1..]; shortArgs
            else                          extraArg

        {options, leftovers}
          = argType {arg: value, options, leftovers, logger}

      {options, leftovers}


