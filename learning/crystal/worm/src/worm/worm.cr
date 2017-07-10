require './segment'

module Worm
  class Worm
    def initialize(
        @length    = 30,
        @width     = 10.0,
        @spacing   = 0.3,
        @turnSpeed = 0.1) # max turn per tick is +/- @turnSpeed radians

      @segments  = [makeSegment]
      @direction = randomDirection
      @radius    = @width / 2

      while @segments.length < @length
        addSegment nextLocation
      end
    end

    def randomDirection
      theta = rand * TAU

      Vector.new
    end

    def addSegment(location = nextLocation)
      @setments.push Segment.new @width, location
    end

    def tickHandler(screen : Screen)
      turn
      addSegment
      head().draw  screen
      tail().erase screen
      dropTail
    end

    def dropTail
      @segments.shift
    end

    def makeSegment(v : Vector)
      Segment.new width: @width, v
    end

    def makeSegment(x = 0, y = 0)
        makeSegment Vector.new x, y
    end

    def nextLocation
      location = head().location + directionVector
      #if location.
    end

    def directionVector
      Vector.new @radius * Math.cos(@direction), @radius * Math.sin(@direction)
    end

    def turn()
      turn rand * 2 * @turnSpeed - @turnspeed
    end

    def turn(amount)
      @direction += amount
    end
  end
end
