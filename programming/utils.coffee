# Let's try this again...

main = ->
  install() if runAsScript

favoritePackages =
  cs: cs = require 'coffee-script'
  R : R  = require 'ramda'

{ curry } = R

Object.assign module.exports, publishable = {
    gather      : gather       = (instream) ->
                    new Promise (resolve, reject) ->
                      buf = null

                      instream
                        .on 'end',          -> resolve buf
                        .on 'error',    (e) -> reject e
                        .on 'data',  (data) ->
                          buf =
                            if buf is null
                              data
                            else
                              Buffer.concat data, buf

    runAsScript : runAsScript  = -> module.main is module
    qw          : qw           = (s) -> s.toString().split /\s+/g

    gopn        : gopn         = Object.getOwnPropertyNames
    gops        : gops         = Object.getOwnPropertySymbols

    hasOwnProp  : hasOwnProp   = R.has
    getOwnProp  : getOwnProp   = R.both R.has, R.prop

    hasProp     : hasProp      = R.hasIn
    getProp     : getProp      = R.prop
    setProp     : setProp      = curry (propname, value, o) -> o[propname] = value

    fnAsProp    : fnAsProp     = (o, pname, fn) ->
      Object.defineProperties o,
        "#{pname}":
          get:         -> fn.call o
          set: (value) -> fn.call o, value
  }

  install       : install      = (namespace = global) ->
    Object.assign namespace, publishable

    Object.assign String::,
      chars: -> @split ''

      words: -> @split /\W+/g

    for method in qw 'every filter find findIndex forEach map'
      String::[method] ?= (args...) -> @chars()[method] args...

main()
