
# A segment of a worm. Initialized with a display, width and location
# Draws itself on creation, removes itself on destruction

module Worm
  class Segment
    def initialize(@display, @width, @location)
      @display.addCircle @location, @width
    end

    def finalize
      @display.removeCircle @location, @width
    end
  end
end
