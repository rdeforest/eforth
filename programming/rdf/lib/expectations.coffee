merge   = Object.assign
tests   = Symbol

addTests = (nameAndTests) ->
  errors = []

  for name, tests of nameAndTests
    if not @[name]
      errors.push  new Error "Invalid test: Expect.#{name} is not defined"
      continue

    if 'function' isnt typeof tests
      errors.push  new Error "Invalid test for #{name}: not a function"
      continue

    Expect.name[tests] = test

  if errors.length is 1
    throw errors[0]

  if errors.length
    throw new Error "There were multiple errors:\n" +
      errors.map((e) -> "#{e.message}\n#{e.stack}").join "\n\n"

defineExpectations = (namesAndApplies) ->
  for name, apply of namesAndApplies
    new Expect "#{name}": apply

class Expect
  constructor: (nameAndApply) ->
    unless 1 is Object.keys(nameAndMangler).length
      throw new Error 'Expect requires an object with a single key'

    for name, @apply of nameAndApply
      if 'function' isnt typeof @apply
        throw new Error 'Value must be a function'

      Expect[name] = @

defineExpectations
  increments: ({options, option}) ->
    options[option] ?= 0
    options[option]++

  toggle: ({options, option}) ->
    # May be useful for options-within-options:
    #
    # $ foo --toggled with toggle --toggled without toggle

    options[option] = not (options[option] ?= false)

  true: ({options, option}) ->
    options[option] = true

  oneValue: ({options, option, value, logger: {warn}, nextArg}) ->
    unless 'string' is typeof value ?= nextArg().value
      warn "Expected value for --#{option} not found"
      return

    if options[options]
      warn "Ignoring --#{option}=#{value}: already set"
      return
    
    options[option] = value

  accumulatesValues: ({options, option, value, logger: {warn}, nextArg}) ->
    unless 'string' is typeof value ?= nextArg().value
      warn "Expected value for --#{option} not found"
      return

    (options[option] ?= []).push value

makeTest = (nameAndDetails) ->
  merge (
    for name, [testsAndValues, butFirst = nop, andFinally = nop] of nameAndDetails
      "#{name}": ->
        {option, processArgv} =
          warnings = 0

          exports.makeGetOpts logger: warn: (msg) -> warnings++

        option '-t', '--test', Expect.toggle

        butFirst option, processArgv

        for [test, value, warningOffset = 0, expectedRemaining = []] in testsAndValues
          test                 = [].concat test
          warningsWas          = warnings
          {options, remaining} = processArgv test

          warnDelta = (warnings - warningsWas)

          assert.equal     warnDelta,
                           warningOffset,
                           "after #{test}, warnings increased by #{warnDelta}, wanted #{warningOffset}"

          assert.equal     options.test,
                           value,
                           "after #{test}, options.test is #{options.test}, wanted #{value}"

          assert.deepEqual remaining,
                           expectedRemaining,
                           "after #{test}, remaing was #{JSON.stringify remaining}, wanted #{JSON.stringify expectedRemaining}"

        andFinally option, processArgv
  )...

addTests merge {},
  makeTest 'increment': [ [ '-t',    1], [ '--test',     2] ]
  makeTest 'toggle':    [ [ '-t', true], [ '--test', false] ]
  makeTest 'true':      [ [ '-t', true], [ '--test', false] ]
  makeTest 'basics':    [ [ [],          undefined              ]
                          [ '-f',        undefined, 1           ]
                          [ 'extra',     undefined, 0, ['extra']] ]

if require.main is module
  process.argv.push '--joe-reporter=console'

  {suite, test} = require './setup-testing'

  suite 'rdf/lib/shell', ->
    suite 'option expectations', ->
      for name, fn of Expect when 'function' is typeof testFn = fn[tests]
        test name, testFn

merge exports, { Expect }

