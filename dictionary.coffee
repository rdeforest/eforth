class Dictionary
  @of: ({@klass, keys}) ->
    @addKey key for key in keys

  constructor: ->
    @keys = {}
    @indexes = {}
    @values = []
    @dbTop = 0
    @defaultKey = null

  setDefaultKey: (keyName) ->
    if not @keys[keyName]
      throw new Error "There is no key named #{keyName}"

    @defaultKey = keyName

  remove: (member) ->
    keys = {}
    memberId = @values.indexOf member

    for keyName, keyFn of @keys
      keys[keyName] = key = keyFn member
      
      if not @indexes[keyName][key]
        BUG "member missing from at least one index"

    for keyName, key of keys
      @indexes[keyName][key]
        .filter ({id, v}) ->
          bug = if id is memberId and v isnt member
                  "id #{id} matches, but values differ"
                else if id isnt memberId and v is member
                  "values match, but ids (#{id}, #{memberId}) differ"

          if bug
            BUG "Inconsistent index for key #{keyName}:" + bug

          return id isnt memberId or v isnt member

  add: (member) ->
    if member not instanceof @klass
      throw new Error "This dictionary only indexes #{@klass.name} objects"

    @values[id = @dbTop++] = member
    @index member, id
    return @

  index: (v, id, onlyKeyName) ->
    for keyName, keyFn of @keys when onlyKeyName in [keyName, undefined]
      key = keyFn v

      (@indexes[key] ?= []).push {id, v}

  addKey: (keyInfo) ->
    if 'string' is typeof keyInfo
      keyInfo = {keyInfo}

    for name, key of keyInfo
      if @keys[name]
        throw new Error "Already have a key named #{name}"

      @keys[name] =
        switch typeof key
          when 'string'   then (o) -> o[key]
          when 'function' then key
          else
            throw new Error "Unknown key type"

      @reindex name

  lookupAll: (keyValue, keyName = @defaultKey) ->
    if not index = @indexes[keyName]
      throw new Error "No such key"

    if not found = index[keyValue]
      throw new Error "Key value not found in index"

    return found

  lookupAny: (keyValue, keyName) ->
    return (@lookupAll keyValue, keyName)[0]

  lookupExact: (keyValue, keyName) ->
    if (found = @lookupAll keyValue, keyName).length > 1
      throw new Error "Multiple matches for that key value"

    return found[0]

  reindex: (keyName) ->
    key = @keys[keyName]
    @indexes[keyName] = {}

    for v, id in @values
      @index v, id, keyName
