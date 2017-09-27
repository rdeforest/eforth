# Because of:
# http://24.hu/app/uploads/2015/12/fejtoro.jpg

class Path
  @paths = []

  constructor: (@isBlue, @a, @b = new Intersection) ->
    @a.addPath @
    @b.addPath @
    @pNum = (Path.paths.push @) - 1
    console.log "#{@pNum}: #{@a.iNum.toString 16} <#{@isBlue and "b" or "r"}> #{@b.iNum.toString 16}"

  inspect: -> "Path #{@pNum}"

  allows: (isBlue) ->
    'boolean' isnt typeof isBlue or
    isBlue    isnt @isBlue

  arriveAt: (from) ->
    switch from
      when @a then @b
      when @b then @a
      else undefined

class Intersection
  @all = []

  constructor: ->
    @paths = new Set
    @iNum = (Intersection.all.push @) - 1
    #console.log @

  addPath: (path) ->
    @paths.add path

  inspect: -> "Stop #{@iNum}"

class Puzzle
  constructor: ->
    @start = new Intersection
    @end   = null

  dykstra: ->
    edge = [[@start, true, []]]

    open = (path, from, trail) ->
      if (     path.allows isBlue) and
         (to = path.arriveAt stop) and
         (to not in trail)
        to

    while edge.length
      [stop, isBlue, trail] = edge.shift()

      for path from stop.paths when to = open path, stop, trail
        return trail if to is @end

        edge.push [to, not isBlue, [trail..., to]]

    return undefined

###

  A--r--B
  b     b
4b7b6-+r8-+
r r r b r r
2b5r+ +r+bC
b b | | | b
1r+-3 9-+rD
r         r
s         e

start-r-1-b-2-r-4-b-7-r-5-b-3-r-6-b-9-r-9-b-6-r-3-b-5-r-7-b-A-r-B-b-8-r-C-b-D-r-end


