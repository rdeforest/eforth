localStorage =
  store: {}
  getItem: (name)        -> localStorage.store[name]
  setItem: (name, value) -> localStorage.store[name] = value

mergeEntries = (entries) ->
  entries.reduce ((o, [k, v]) -> o[k] = v), {}

objMorpher = (fn) ->
  (o) ->
    entries = Object
      .entries(o)
      .map ([k, v]) -> [k, (fn k, v) ? v]

    mergeEntries entries

class Hax
  constructor: ->
    @name = 'hax'
    return Hax.singleton ?= @

  toString: ->
    proto = @constructor::
    self = mergeEntries Object.getOwnPropertyNames(proto).map (prop) -> [prop, proto[prop]]
    JSON.stringify @stringifyFns self

  pull:     -> localStorage.getItem @name
  push: (s) -> localStorage.setItem @name, s

  save:     -> @push @toString()
  load:     ->
    oldHax = JSON.parse @toString()
    newHax = JSON.parse @pull()

    if diff = @compare oldHax, newHax
      console.log "changes:", diff

    Object.assign @, @compileFns JSON.parse newHax

  compare: (a, b) ->
    diff = []

    comp = (u, v) -> if 'object' is typeof v then @compare u, v else [u, v]

    for k, v of b when v isnt u = a[k]
      diff.push [k, subDiff] if subDiff = comp u, v

    for k, v of a when not diff[k] and u isnt v = b[k]
      diff.push [k, subDiff] if subDiff = comp u, v

    diff.length and mergeEntries diff
    

  isObj: (o) -> 'object' is typeof o
  isFnStr: (s) -> s?.startsWith?('function () {') and s.endsWith '}'
    
  compileFns: objMorpher (k, v) ->
    switch
      when @isFnStr v then eval "(#{v})"
      when @isObj   v then @compileFns v
    
  stringifyFns: objMorpher (k, v) ->
    switch typeof v
      when 'function' then v.toString()
      when 'object'   then @stringifyFns v

  addJQuery: ->
    unless 'string' is typeof $?.fn?.jquery
      (jQueryScriptTag = document.createElement 'script').setAttribute 'src', 'https://code.jquery.com/jquery-3.2.1.min.js'
      document.body.appendChild jQueryScriptTag

  unlock: -> @addJQuery(); $('disable').removeClass 'disable'

hax = new Hax

#console.log Object.getOwnPropertyNames Object.getPrototypeOf hax
#console.log hax.stringifyFns Object.getPrototypeOf hax
console.log JSON.parse hax.toString()
