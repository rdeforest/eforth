class SecretLocation
  constructor: (@pad, @offset, @length) ->

  get: -> @pad.read @offset, @length

  set: (data) ->
    @pad.append data
      .then (@offset, @length) ->

class SecretPad
  constructor: (@assembler) ->
    @UUID = makeUUID()
    @length = 0
    @writers = new Promise.resolve true

  addSecret: (secret) ->
    @secrets.push secret
    secret._addLocation this

  append: (data) ->
    @writers = @writers.then ->
      offset = @length
      len = data.length

      @length += len
      [offset, len]

  writeOut: (offset, data) ->

  readIn: (offset, length) ->

    
class Secret
  constructor: (@name, @notes, @opts = {}) ->
    @data = undefined
    @history = []
    @locations = []

  set: (@data) ->
    @locations.map (loc) ->
      loc.set @data
    
  # Called by SecretPad

  _addLocation: (pad) ->
    @locations.push pad

  _delLocation: (pad) ->
    @locations = @locations.filter (e) -> not (e is pad)
