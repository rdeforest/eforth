process   = require 'process'
fs        = require 'fs'
path      = require 'path'
readline  = require 'readline'
util      = require 'util'

readFile  = util.promisify fs.readFile
writeFile = util.promisify fs.writeFile

{ RewindableStepSequence } = require './rewindable'

MILLISECONDS_PER_DAY =
  1000 * # milliseconds
    60 * # seconds
    60 * # minutes
    24   # hours

module.exports.Tracker =
class Tracker
  constructor: (dir = __dirname, fileName = "test.json") ->
    @filePath = path.resolve dir, fileName
    @today    = new Date
    @dayNum   = @today.getDay()

  @defaultHealed:
    current: 0
    max: 14
    rampingDownDays: 0
    rampingDownRate: 1

  @defaultUnspent:
    current: 0
    max: 4
    rampingDownDays: 0
    rampingDownRate: 1

  @defaultHealing: ->
    tokensPerDay = Math.floor Rotator.defaultHealed.max / 7
    [0..6].map -> tokensToDistribute

  toString: ->
    JSON.stringify @, 0, 2

  orderDrink: ->
    if @unspent.current < 1
      throw new Error "Tokens exhausted"

    if @drinking
      throw new Error "You haven't finished your last drink."

    if Date.now() - @lastDrinkStarted < @msBetweenDrinks
      throw new Error "It hasn't been long enough since your last drink."

    @lastDrinkOrdered = Date.now()
    @drinking = true
    @unspent.current--

    @commit()

  finishDrink: ->
    if not @drinking
      throw new Error "You already finished your last drink."

    @lastDrinkFinished = Date.now()
    @drinking = false
    @spent++

    @commit()

  load: ->
    readFile @filePath
      .then (buf) =>
        try
          data = JSON.parse buf
        catch e
          throw "failed to parse content of #{@filePath}: #{e.message}"

        { @lastRotationMs    = Date.now() - MILLISECONDS_PER_DAY
          @healed            = Rotator.defaultHealed
          @healing           = Rotator.defaultHealing()
          @unspent           = Rotator.defaultUnspent
          @spent             = 0
          @prompt            = true
          @lastDrinkFinished = Date.now()
        } = data

        @lastRotationDate    = new Date @lastRotationMs

        if 0 > extraTokens = @healed.max - @tokensInSystem()
          throw "token shortage?\n#{@}"

        @healed.current += extraTokens

  tokensInSystem: ->
    [ @healed .current
      @unspent.current
      @spent
      @healing...
    ].reduce (a, b) -> a + b

  commit: (changes = []) ->
    (new RewindableStepSequence)
      .addStep desc: 'make changes',
            forward: -> changes.forEach ({change}) -> change()
            reverse: -> console.log "Commit failed"
      .addStep desc: 'backup current',
            forward: => copy @filePath, backup = @filePath + "-old"
      .addStep desc: 'write to new',
            forward: => writeFile (tmp = @filePath + "-new"), @
            reverse: => unlink tmp
      .addStep desc: 'copy new to current',
            forward: => copy tmp, @filePath
      .addStep desc: 'cleanup',
            forward: =>
              try
                unlink backup
                unlink tmp

module.exports.Rotator =
class Rotator
  constructor: (@tracker) ->

  rotate: ->
    @tracker.load()
      .then (loaded) =>
        @calculateChanges()
        @confirm()
      .then => @tracker.commit @changes
      .catch (err) =>
        console.log err
        process.exit 1
      .then -> console.log 'done'

  rotatableDays: ->
    msSinceLast = Date.now() - @tracker.lastRotationMs
    days = Math.floor msSinceLast / MILLISECONDS_PER_DAY

    if 7 <= days
      throw "More than a week since last rotation (#{days} days)?"
    else if days > 0
      [@tracker.lastRotationDate.getDay()..@tracker.dayNum - 1]
    else
      []

  calculateChanges: ->
    @changes = []

    for day in @rotatableDays()
      @changes = @changes.concat [
        @addHealed()
        @emptySpent()
        @refillUnspent()
      ].filter (change) -> change

    if @changes.length
      @changes.push @tracker.updateLastRotated Date.now()

  addHealed: ->
    if healed = @tracker.healing[@tracker.dayNum]
      change : =>
        @tracker.healed.current += healed
        @tracker.healing[@tracker.dayNum] = 0
      desc   : "Heal #{healed} points."

  emptySpent: ->
    if @tracker.spent
      change : =>
        @tracker.healing[@tracker.dayNum] = @tracker.spent
        @tracker.spent = 0
      desc   : "Queue #{@tracker.spent} points for healing."

  refillUnspent: ->
    if 0 < needed = @tracker.maxUnspent - @tracker.unspent
      replenished = Math.min needed, @tracker.healed.current

      change : =>
        @tracker.unspent         += replenished
        @tracker.healed.current  -= replenished
      desc: "Refill #{replenished} points."

  updateLastRotated: ->
    newDate = Math.min @tracker.lastRotated + MILLISECONDS_PER_DAY, Date.now()
    newDateStr = (new Date newDate).toString()

    change : => @tracker.lastRotated = newDate
    desc   : "Change last rotation time to #{newDateStr}"

  confirm: ->
    new Promise (resolve, reject) =>
      unless @changes.length
        return reject "no changes"

      @showChanges

      if not @tracker.prompt
        return resolve()

      rl = readline.createInterface
        input: process.stdin
        output: process.stdout
        
      rl.question @confirmationPrompt(), (answer) ->
        if answer and not answer.match /y/
          return reject "canceled"

        resolve()

  confirmationPrompt: ->
    ([ "The following changes will be made:" ]
      .concat @changes.map ({desc}) -> desc
      .join "\n  "
    ) + "\n Proceed (Y/n)? "


