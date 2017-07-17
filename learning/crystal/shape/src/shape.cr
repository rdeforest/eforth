require "./shape/*"
require "vector"

module Shape
  macro argsToPoint(name, content)
    def {{name}}(p : Point)
      {{content}}
    end

    def {{name}}(*, x, y)
      p = Point.new Vector.new x, y
      {{content}}
    end

    def {{name}}(*, i, j)
      p = Point.new Vector.new i, j
      {{content}}
    end
  end

  class Point
    def initialize(v : Vector)
      # Because NO SIDE EFFECTS! or whatever.
      @v = Vector.new v.i, v.j
    end

    argsToPoint initialize, {
      @v = p.v
    }

    def x() @v.i end
    def y() @v.j end
    def v() @v   end

    def -(other) Point.new(@v - other.v) end
    def +(other) Point.new(@v + other.v) end
  end

  abstract class Shape
    abstract def draw(target)

    def initialize(@origin : Point)
    end

    def shift(x, y)
      @origin = @origin + Point.new x, y
    end
  end

  class Circle < Shape
    def initialize(
end
