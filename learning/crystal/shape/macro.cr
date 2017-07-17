# Trying out this "macro" stuff...

require "vector"

macro argProcessor(name, body)
  def {{name}}(*, x, y)
    {{body}} @v = Vector.new x, y
  end

  def {{name}}(*, i, j)
    {{body}} @v = Vector.new i, j
  end
end

class Point
  def initialize(@v : Vector)
  end

  argProcessor initialize, Point.new
end
