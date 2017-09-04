gnuplot = require 'gnuplot'

allAre = (list, areWhat) ->
  -1 is list.findIndex (e) -> not areWhat e

allStrings = allAre (e) ->
  'string' is typeof e or e instanceof String

allNumbers = allAre (e) ->
  'number' is typeof e or
  e instanceof Number  or
  Number.isNaN e # OH THE IRONY

class PlotFunction
  constructor: (info) ->
    switch
      when info instanceof PlotFunction then return info

      when @isGenerator = info instanceof GeneratorFunction
        @generator = info

      when @isFunction = 'function' is typeof info
        @generator = ->
          state = {}

          yield ret until (ret = info state) in [null, undefined]

      when not Array.isArray info
        throw new Error "unsupported PlotFunction type"
        
      when allStrings info then
        @fnExpressions = info

      when allNumbers info then
        @generator = -> yield n for n in info


class Element
  constructor: (@fn, @opts = {}) ->
    @fn = new PlotFunction @fn

class Range
  constructor: (info...) ->
    info = info[0] if info.length is 1

    if Array.isArray info
      [@from, extra..., @to]

    else
      { @from
        @to
      } = info

  toString: ->
    "[#{@from or ''}:#{@to or ''}]"

# handles translation from xrange: [-10, 10] to "xrange [-10:10]"
set   = (settings) ->
  for setting, value of settings
    if xltr = settingTranslator setting
      value = xltr setting, value

    gnuplot.set "#{setting} #{value}"

plot  = (elements...) ->
  ranges = []

  while elements[0] not instanceof Element
    ranges.push elements.shift()

splot = (elements...) ->
  ranges = []

  while elements[0] not instanceof Element
    ranges.push elements.shift()

Object.assign exports, {Element, Range}, dsl:  {set, plot, splot}

exports.plot = (ranges, fns, opts = {}) ->
  if 'function' is typeof ranges[0]
    [ranges, fns, opts = {}] = [[], ranges, fns]

  ranges = ranges.map (r) -> new Range   r
  fns    = fns   .map (f) -> new Element f
