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

  load: ->
    readFile @filePath
      .then (buf) =>
        try
          data = JSON.parse buf
        catch e
          throw "failed to parse content of #{@filePath}: #{e.message}"

        { @lastRotationMs = Date.now() - MILLISECONDS_PER_DAY
          @healed         = 7
          @healing        = [0..6].map -> 1
          @unspent        = 0
          @spent          = 0
          @prompt         = true
        } = data

        @lastRotationDate = new Date @lastRotationMs

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
        @healed += healed
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
      replenished = Math.min needed, @healed

      change : =>
        @unspent += replenished
        @healed  -= replenished
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
