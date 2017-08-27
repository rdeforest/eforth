# Let's try this again...

favoritePackages =
  cs: cs = require 'coffee-script'
  R : R  = require 'ramda'

{ curry } = R

Object.assign module.exports, publishable = {
    qw         : qw          = (s) -> s.toString().split /\s+/g

    gopn       : gopn        = Object.getOwnPropertyNames
    gops       : gops        = Object.getOwnPropertySymbols

    hasOwnProp : hasOwnProp  = R.has
    getOwnProp : getOwnProp  = R.both R.has, R.prop

    hasProp    : hasProp     = R.hasIn
    getProp    : getProp     = R.prop
    setProp    : setProp     = curry (propname, value, o) -> o[propname] = value

    fnAsProp   : fnAsProp    = (o, pname, fn) ->
      Object.defineProperties o,
        "#{pname}":
          get:         -> fn.call o
          set: (value) -> fn.call o, value
  }

  install    : (namespace = global) ->
    Object.assign namespace, publishable

    Object.assign String::,
      chars: -> @.split ''

      words: -> @.split /\W+/g

      el: (attributes) ->
        if attributes
          "<#{@toLowerCase()} #{
            ("#{HTML.quote k.toLowerCase()}=\"#{HTML.quote v}\"" for k, v of attributes).join ' '
          }>"

    for method in qw 'every filter find findIndex forEach map'
      String::[method] ?= (args...) -> @chars[method] args...


