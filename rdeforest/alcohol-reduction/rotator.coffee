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

class module.exports.Rotator
  constructor: (dir, fileName) ->
    @filePath = path.resolve dir, fileName
    @today    = new Date
    @dayNum   = @today.getDay()

  rotate: ->
    @load()
      .then (loaded) =>
        @calculateChanges()
        @confirm()
      .then => @commit()
      .catch (err) =>
        console.log err
        process.exit 1

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

        { @lastRotationMs = Date.now() - MILLISECONDS_PER_DAY
          @healed         = Rotator.defaultHealed
          @healing        = Rotator.defaultHealing()
          @unspent        = Rotator.defaultUnspent
          @spent          = 0
          @prompt         = true
        } = data

        @lastRotationDate = new Date @lastRotationMs

        if 0 > extraTokens = @healed.max - @tokensInSystem()
          throw "token shortage?\n#{@}"

        @healed.current += extraTokens

  tokensInSystem: ->
    [ @healed .current
      @unspent.current
      @spent
      @healing...
    ].reduce (a, b) -> a + b

  rotatableDays: ->
    msSinceLast = Date.now() - @lastRotationMs
    days = Math.floor msSinceLast / MILLISECONDS_PER_DAY

    if 7 <= days
      throw "More than a week since last rotation (#{days} days)?"
    else if days > 0
      [@lastRotationDate.getDay()..@dayNum - 1]
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
      @changes.push @updateLastRotated()

  addHealed: ->
    if healed = @healing[@dayNum]
      change : =>
        @healed.current += healed
        @healing[@dayNum] = 0
      desc   : "Heal #{healed} points."

  emptySpent: ->
    if @spent
      change : =>
        @healing[@dayNum] = @spent
        @spent = 0
      desc   : "Queue #{@spent} points for healing."

  refillUnspent: ->
    if 0 < needed = @maxUnspent - @unspent
      replenished = Math.min needed, @healed.current

      change : =>
        @unspent         += replenished
        @healed.current  -= replenished
      desc: "Refill #{replenished} points."

  updateLastRotated: ->
    newDate = Math.min @lastRotated + MILLISECONDS_PER_DAY, Date.now()
    newDateStr = (new Date newDate).toString()

    change : => @lastRotated = newDate
    desc   : "Change last rotation time to #{newDateStr}"

  confirm: ->
    new Promise (resolve, reject) =>
      unless @changes.length
        return reject "no changes"

      @showChanges

      if not @prompt
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

  commit: ->
    @changes.forEach ({change}) -> change()
    writeFile @filePath, JSON.stringify @
    throw "done"
