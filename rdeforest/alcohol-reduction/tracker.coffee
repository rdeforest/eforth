process   = require 'process'
fs        = require 'fs'
path      = require 'path'
readline  = require 'readline'
util      = require 'util'

readFile  = util.promisify fs.readFile
writeFile = util.promisify fs.writeFile

MILLISECONDS_PER_DAY =
  1000 * # milliseconds
    60 * # seconds
    60 * # minutes
    24   # hours

Object.assign module.exports, {
    Tracker
    Rotator
  }

class Tracker
  constructor: (dir, fileName) ->
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

  commit: (changes) ->
    changes.forEach ({change}) -> change()
    copy @filePath, backup = @filePath + "-old"
      .catch (err) => throw "backup of #{@filePath} failed: #{err.message}"
      .then => writeFile (tmp = @filePath + "-new"), @
      .catch (err) =>
        msg = "write to #{tmp} failed: #{err.message}"
        (unlink tmp
          .then        -> unlink backup
          .catch (err) -> throw msg + "\n\nAnd then cleanup failed: #{err.message}"
          .then        -> throw msg)
      .then => copy tmp, @filePath
      .catch (err) =>
        msg = "copy from #{tmp} to #{@filePath} failed: #{err}"
        (unlink tmp
      .then => unlink backup
      .then =>
        rename tmp, 
      .catch (err) ->
        unlink tmp
        throw err

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


