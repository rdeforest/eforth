require "math"

# Support for shapes more advanced than point, line and rectangle.

module Shape
  PI = Math::PI
  TAU = PI * 2

  class Oval

    def initialize(@x : Float64, @y : Float64, @width : Float64, @height : Float64)
    end

    def drawOn(renderer)
      angles = @radius * PI / 2
      angle = 0.0
      sliceRadians = TAU / angles

      while angle < TAU
        theta = angle * sliceRadians

        dx = @width  * Math.cos angle
        dy = @height * Math.sin angle

        angle += theta

        # No need to re-calculate the sin/cos for the mirrored corners.
        renderer.draw_point @x + dx, @y + dy
        renderer.draw_point @x - dx, @y + dy
        renderer.draw_point @x - dx, @y - dy
        renderer.draw_point @x + dx, @y - dy
      end
    end
  end

  class Circle < Oval
    def initialize(x : Float64, y : Float64, radius : Float64)
      super x, y, radius, radius
    end
  end
end
