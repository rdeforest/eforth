A case for dynamic declaration of variables

    addVars require,
      User        : 'iam-user'
      Account     : 'isen-account'
      MaterialSet : 'odin-material-set'

Of course ES6 [addresses](http://es6-features.org/#DefaultWildcard) this
specific use case with the import/export stuff:

  import * as User        from 'iam-user'
  import * as Account     from 'isen-account'
  import * as MaterialSet from 'odin-material-set'

But that is far less succinct. I think the solution to my problem may be an
extension to CoffeeScript to support late var declarations.

# An option

    addVars = (initializer = (v) -> v, vars) ->
      for name, initArg of vars
        ((value) -> "var #{name} = value;")

    # FIXME: should use makeValue for assigned value
    makeVar = (name, value) ->
      switch typeof value
        when 'function' then makeFunction name, value
        when 'object'   then makeObject   name, value
        else                 makeVarStr   name, value

    makeValue = (value) ->
      switch typeof value
        when 'function' then makeFunction  value
        when 'object'   then makeObject    value
        else                 makePrimative value

    # XXX: need to getPrototypeOf, setPrototypeOf, descriptors, etc
    makeFunction = (fn) ->
      "Object.Assign (-> fn = #{fn.toString()}), #{jsonWithRefs fn}"

    makeObject value
      strValue = jsonWithRefs value
      "Object.assign {}, #{strValue}"

    jsonWithRefs = (obj) ->
      jsonLinesWithRefs(obj).join "\n"

    jsonLinesWithRefs = (obj, refs = new Map) ->
      [ "{"
        ( for k, v of obj
            valueStr = makeValue v

            "#{k}: " +
              if refs.has v
                "#{refs.get v}"
              else
                refs.add v, refName = "ref" + refs.size
                "#{refName} = " + valueStr
        ) .map (s) -> "  " + s
        "}"
      ]

# Er, wait

    class Deconstructor
      constructor: (@value, opts, @refs = new Map) ->
        @opts = Object.assign {
            indent: 2
            extraParens: false
            newline: '\n'
          }, opts

        @root = switch typeof @value
          when 'function' then new FnDecon   @value, @refs
          when 'object'   then new ObjDecon  @value, @refs
          when 'symbol'   then new SymDecon  @value, @refs
          when 'string'   then new StrDecon  @value, @refs
          else                 new PrimDecon @value, @refs

      @ref: ->
        if @refs.has @value
          return @refs.get data

        ref =
          name: "ref#{@refs.size}"
          wrapper: this

        @refs.set data, ref

      varDecls: ->
        @refs.forEach (value, ref) ->
          "var #{ref.name} = #{ref.wrapper};"

      toFunction: ->
        [ "(function () {"
          (@varsDecls()
            .concat [ "return ( #{JSON.stringify @value} )" ]
            .map (l) -> " ".repeat indent)...
          "})()"
        ]

      _indent: (list, width) -> list.map (el) -> " ".repeat(width) + el

      toList: (listSoFar = @ref) ->
        if @opts.extraParens
          if listSoFar.length is 1
            [ "( #{listSoFar[0]} )" ]
          else
            [ "( " + listSoFar[0]
              @_indent listSoFar[1..], indent
              ")"
            ]
        else
          listSoFar

      toString: ->
        @toList().join opts.newline


    class PrimDecon extends Deconstructor

    class ObjDecon extends Deconstructor
      constructor: (args...) ->
        super args...
        @proto = Object.getPrototypeOf @value
        @pairs =
          for k, v of @value
            kStr =
              if 'symbol' is typeof k
                @ref k
              else
                JSON.stringify k

            vStr =
              @ref v

            [k, v]

      toList: ->
        [
        ]

    class FnDecon extends ObjDecon
      constructor: (args...) ->
        super args...
        @code = @value.toString().split "\n"

      toList: ->
        objStr = super()
        fnStr = "(" + @code + ")"
        [ "function () {",
          "  Object.assign #{fnStr}, #{objStr}"
          "  return fn"
        ]

    class SymDecon extends ObjDecon
      constructor: (args...) ->
        super args...

      toString: ->
        symName = @value.toString()
        symName = @symName.substr 7, @symName.length - 8
        "Symbol #{JSON.stringify @symName}"
