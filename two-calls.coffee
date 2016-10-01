classes =
  Person: class Person
    constructor: (@name, info = {}) ->
      { @role         = "person of mystery!"
        @rollingSince = "nobody knows!"
      } = info

      @preferences = {}
      @getPreferences()
      @listeners = []

    getPreferences: ->
      classes.Example.cleverServer 'prefs'
        .then ({fromUrl, data}) ->
          @preferences = data
          @emit 'changed'

    on: (event, fn) ->
      @listeners[event].push fn

    emit: (event, details...) ->
      for l in @listeners[event] or []
        try
          l.fn details...

  Example:
    run: ->
      (@p = @makeCallPromise 'basics')
        .then ({fromUrl, data}) ->
          $('table').DataTable
            data: data
            columns: [
              { data: 'name'           }
              { data: 'role'           }
              { data: 'rollingSince'   }
              { data: @makeDynamicCell }
            ]

    log: (msg) -> $('ul').append $("<li>").append $("<pre>#{msg}</pre>")

    columnData: (info) -> {key, value} for key, value of info

    memoize: (fn) ->
      done = false

      (args...) ->
        if not done
          done =
            try
              result = fn args...
              -> result
            catch e
              -> throw e

        done()

    jsonData:
      basics:
        try
          for name in ['Alice', 'Bob', 'Charles']
            { name, role: @randomRole(), rollingSince: @randomDate() }
        catch e
          @log "Error: " + e.stack

      prefs:
        'Alice'   : @columnData poetry    : 3, sleep   : 2, games : 10
        'Bob'     : @columnData eat       : 7, tv      : 9, work  :  8
        'Charles' : @columnData horseshoe : 5, grenade : 3, nuke  :  1

    fakeServer: (url, cb) ->
      respond = ->
        if d = @jsonData[url]
          cb null, Object.assign fromUrl: url, data: d
        else
          cb new Error "404"

      latency = 300 + Math.random() * 600

      setTimeout respond, latency

    makeCallPromise: (url) ->
      new Promise (resolve, reject) ->
        @fakeServer url, (err, result) ->
          if err
            return reject err

          resolve result

    cleverServer: (url) ->
      (@cleverServer[url] or= @memoize @makeCallPromise) url

    randomRole: ->
      roles = ['slacker', 'hacker', 'resident', 'president']
      roles[Math.floor Math.random() * roles.length]

    randomDate: ->
      new Date Date.now() - 1000 * 86400 * 365 * 5 * Math.random()

    makeDynamicCell: (row, type, newValue, meta) ->
      el = $("<table>")

      person = new classes.Person row[0], role: row[1], rollingSince: row[2]
        .on 'changed', ->
          $(el).DataTable
            data: person.preferences
            columns: [
              { data: "key"   }
              { data: "value" }
            ]

      return el

try

catch e
  @log e.msg, e.stack
