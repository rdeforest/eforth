linesToParagraphs  =
paragraphsToString =
newStringProto     =
qw   = printf =
warn = print  = sprintf =
log  = merge  = getters =
  null

require './module'
  .defineModule
    comment: """
        Create an extended version of String. If options.install, extend
        provided String.
      """

    defaults:
      options: String: String, install: false
      imports: logger: console

    ({options: {String: newString, install}
      imports: logger: log
    }) ->
      OldString = merge String

      if not newString
        newString =
          Object.create OldString,
            prototype:
              value: newStringProto

      newString.toString = toString

      { String: newString
        StringArray, ParagraphArray
      }

newStringProto = Object.create OldString::,
  getters
    merge
      qw:          -> qw @
      split: (sep) -> new StringArray OldString::split.call @, sep
      {print, printf, sprintf}

toString = (o, args...) ->
  switch o
    when undefined then 'undefined'
    when null      then 'null'
    else                o.toString args...

vsprintf = (values) ->
  {FORMAT_PATTERN, FORMATTER} = @constructor

  FORMATTER values, @match FORMAT_PATTERN

class StringArray extends Array
  constructor: (strings) ->
    if not Array.isArray strings
      throw new Error 'Cannot construct StringArray from non-array'

    StringArray.from strings.map (s) -> toString s

  toParagraphs: ->
    return [] unless lines.length

    [lines] = lines unless lines.length > 1

    new ParagraphArray
      @ .map /^$/, '\n'
        .join '\n'
        .split '\n\n'
        .map (s) -> s.replace /\n/g, ' '

class ParagraphArray extends StringArray
  toString: ->
    @join '\n\n'

merge = (objs...) -> Object.assign {}, objs...

qw = (s) -> s.split /\s+/

getters = (namesAndValues) ->
  namesAndValues[name] = get: value for name, value of namesAndValues

  namesAndValues

