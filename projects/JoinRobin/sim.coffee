if true
  # Utility
  _ = require 'underscore'

  pretty = (x) -> JSON.stringify x, 0, 2

  idMakers = {}

  idMaker = (setName) ->
    nextId = 1

    Object.defineProperty idMakers, setName, get: -> nextId++

  idMaker 'user'
  idMaker 'room'

  # can get fancier later
  log = ->
    #console.log

class User
  constructor: ->
    @id = idMakers.user

    @rooms = []
    @journeys = []

  join: (@room) ->
    @rooms.push @room.id

  leave: ->
    @journeys.push @rooms
    @rooms = []

  toString: ->
    "User[#{@id}]: tier #{@rooms.length}, #{@journeys.length} train(s)"

voteDelay = [0, 1, 2, 4, 8, 16, 30]

class Room
  constructor: ({@users, rooms, @created}) ->
    @id = idMakers.room

    tier = 1

    if rooms
      [a, b] = rooms
      @users = a.users.concat b.users
      tier = a.users[0].rooms.length

    @users.map (u) =>
      if not u
        console.log @users
        throw new Error 'wat'
      u.join this

    @voteAfter = now + if tier < voteDelay.length then voteDelay[tier] else 30

  canVote: (now) -> now >= @voteAfter

  trimUsers: ->
    zeros = @users.splice 1, @users.length
    zero.leave() for zero in zeros
    return zeros


class World
  constructor: (startingUsers = 0) ->
    @users = []
    @tiers = []
    @simMinute = 0
    @runningTask = null
    @lastUpdate = null

    @conf =
      updateInterval: 1000
      iterationDelay: 1
      stopAt:
        minute: 24 * 60
        maxTier: 18
        noActivity: true

    @makeUser() for n in [1..startingUsers]

  makeUser: -> @users.push new User

  createRoom: (a, b) -> @installRoom new Room created: @simMinute, users: [a, b]
  mergeRooms: (a, b) -> @installRoom new Room created: @simMinute, rooms: [a, b]

  installRoom: (room) -> (@tiers[room.tier] or= []).push room

  assignFreeUsers: ->
    newRooms = Math.floor @users.length / 2

    for counter in [1 .. newRooms]
      @createRoom (@users.splice 0, 2)...

    return newRooms

  driveThatTrain: ->
    newRooms = roomsWaitingToVote = 0

    for tier, idx in @tiers
      while tier.length > 1 and tier[1].canVote @simMinute
        [a, b, tier...] = tier

        @mergeRooms a, b
        newRooms++

      @tiers[idx] = tier

      if tier.length > 1
        roomsWaitingToVote += tier.length

        if tier[0].canVote @simMinute
          roomsWaitingToVote--

    return [newRooms, roomsWaitingToVote]

  trimUsers: ->
    trimmed = 0

    for tier in @tiers
      for room in tier
        @users = @users.concat (zeros = room.trimUsers())
        trimmed += zeros.length

    return trimmed

  start: (opts = {}) ->
    _.extend this, opts
    console.log "Starting with: #{pretty @conf}"

    @stop()
    @lastUpdate = Date.now() - @conf.updateInterval
    @runningTask = setInterval (=> @iterate()), @conf.iterationDelay

  stop: ->
    if @runningTask
      clearInterval @runningTask
      @runningTask = null
      console.log @report()

  iterate: ->
    usersFreed        = 0 and @trimUsers()
    newRooms          = @assignFreeUsers()
    [merged, waiting] = @driveThatTrain()

    activity = newRooms + merged + usersFreed
    progress = activity + waiting

    if progress
      @simMinute++

      if (now = Date.now()) - @lastUpdate > @updateInterval
        console.log @report {newRooms, merged, waiting}
        @lastUpdate = now

    stopAt = @conf.stopAt

    @stop() if stopAt.noProgress  and progress is 0                   or
               stopAt.noAcitivity and activity is 0                   or
               stopAt.minute      and @simMinute >= stopAt.minute     or
               stopAt.maxTier     and @tiers.length >= stopAt.maxTier

  tierReport: ->
    @tiers
      .map (tier) -> tier.length.toString()
      .join ", "

  report: (info = {}) ->
    {newRooms, merged, waiting} = info
    report = [ "Minute: #{@simMinute}," ]
    report.push "new: #{newRooms}," if newRooms
    report.push "merged: #{merged}," if merged
    report.push "waiting: #{waiting}," if waiting
    report.push "tiers: #{@tierReport()}"
    report.join " "

_.extend global,
  User: User
  Room: Room
  World: World
  log: log
  pretty: pretty
